///|
/// Computed-value interpolation for CSS animations.
///
/// CSS animations interpolate *computed values*; the result is later resolved
/// to a used value by the layout engine (exactly like a static computed value).
/// This module therefore stays layout-independent: it interpolates already
/// computed values (px lengths, percentages, numbers, colors) and leaves
/// used-value resolution (% -> px, `auto`, intrinsic sizing) to the consumer.

///|
/// A computed value that can take part in animation interpolation. Anything not
/// representable here (or interpolated between mismatched kinds) animates
/// discretely (a 50% jump).
pub(all) enum AnimatableValue {
  Number(Double)
  Length(Double) // px
  Percent(Double) // ratio: 0.5 == 50%
  Color(@values.Color)
  /// Non-interpolable / unsupported computed value; animates discretely.
  Discrete(String)
} derive(Eq)

///|
pub impl Show for AnimatableValue with output(self, logger) {
  match self {
    Number(v) => logger.write_string("Number(\{v})")
    Length(v) => logger.write_string("Length(\{v})")
    Percent(v) => logger.write_string("Percent(\{v})")
    Color(c) => {
      logger.write_string("Color(")
      c.output(logger)
      logger.write_string(")")
    }
    Discrete(s) => logger.write_string("Discrete(\{s})")
  }
}

///|
fn lerp(a : Double, b : Double, t : Double) -> Double {
  a + (b - a) * t
}

///|
/// Round to the nearest integer and clamp to the 0-255 color-channel range.
fn lerp_channel(a : Int, b : Int, t : Double) -> Int {
  let v = lerp(a.to_double(), b.to_double(), t)
  let r = (v + 0.5).to_int()
  if r < 0 {
    0
  } else if r > 255 {
    255
  } else {
    r
  }
}

///|
/// Interpolate two colors in sRGB. Alpha is interpolated linearly.
fn interpolate_color(
  a : @values.Color,
  b : @values.Color,
  t : Double,
) -> @values.Color {
  @values.Color::rgba(
    lerp_channel(a.r, b.r, t),
    lerp_channel(a.g, b.g, t),
    lerp_channel(a.b, b.b, t),
    lerp(a.a, b.a, t),
  )
}

///|
/// Interpolate between two computed values at eased progress `t` in [0, 1].
/// Matching numeric kinds interpolate linearly; colors interpolate in sRGB;
/// any mismatched or non-interpolable pair animates discretely (jumps at 0.5).
pub fn interpolate(
  from : AnimatableValue,
  to : AnimatableValue,
  t : Double,
) -> AnimatableValue {
  match (from, to) {
    (Number(a), Number(b)) => Number(lerp(a, b, t))
    (Length(a), Length(b)) => Length(lerp(a, b, t))
    (Percent(a), Percent(b)) => Percent(lerp(a, b, t))
    (Color(a), Color(b)) => Color(interpolate_color(a, b, t))
    _ => if t < 0.5 { from } else { to }
  }
}

///|
/// One typed keyframe: an offset in [0, 1], the computed value at that offset,
/// and the easing governing interpolation *to* the next keyframe.
pub(all) struct AnimatableKeyframe {
  offset : Double
  value : AnimatableValue
  easing : @values.Easing
}

///|
pub fn AnimatableKeyframe::new(
  offset : Double,
  value : AnimatableValue,
) -> AnimatableKeyframe {
  { offset, value, easing: @values.Easing::Linear }
}

///|
pub fn AnimatableKeyframe::with_easing(
  offset : Double,
  value : AnimatableValue,
  easing : @values.Easing,
) -> AnimatableKeyframe {
  { offset, value, easing }
}

///|
/// A typed keyframe effect: keyframes (sorted by offset) plus timing. Mirrors
/// `NumericKeyframeEffect` but interpolates `AnimatableValue` computed values.
pub(all) struct AnimatableKeyframeEffect {
  keyframes : Array[AnimatableKeyframe]
  timing : EffectTiming
}

///|
/// Build a typed keyframe effect. Returns None if there are no keyframes.
/// Keyframes are assumed to be sorted by non-decreasing offset.
pub fn AnimatableKeyframeEffect::new(
  keyframes : Array[AnimatableKeyframe],
  timing : EffectTiming,
) -> AnimatableKeyframeEffect? {
  if keyframes.length() == 0 {
    None
  } else {
    Some({ keyframes, timing })
  }
}

///|
/// Sample the computed value at normalized progress `progress` in [0, 1] within
/// one iteration. Values before the first / after the last keyframe clamp to the
/// endpoint value.
pub fn AnimatableKeyframeEffect::sample_progress(
  self : AnimatableKeyframeEffect,
  progress : Double,
) -> AnimatableValue {
  let kfs = self.keyframes
  let p = if progress < 0.0 {
    0.0
  } else if progress > 1.0 {
    1.0
  } else {
    progress
  }
  let first = kfs[0]
  if p <= first.offset {
    return first.value
  }
  let last = kfs[kfs.length() - 1]
  if p >= last.offset {
    return last.value
  }
  for i = 0; i < kfs.length() - 1; i = i + 1 {
    let start = kfs[i]
    let end = kfs[i + 1]
    if p >= start.offset && p <= end.offset {
      let span = end.offset - start.offset
      if span <= 0.0 {
        // Coincident offsets: jump to the later keyframe's value.
        return end.value
      }
      let local_progress = (p - start.offset) / span
      let eased = start.easing.sample(local_progress)
      return interpolate(start.value, end.value, eased)
    }
  }
  last.value
}

///|
/// Sample the computed value at `local_time` (ms on the effect's local
/// timeline). Returns None when the timing model produces no active value
/// (e.g. a non-filled before/after phase).
pub fn AnimatableKeyframeEffect::sample(
  self : AnimatableKeyframeEffect,
  local_time : Double,
) -> AnimatableValue? {
  let computed = self.timing.at(local_time)
  match computed.transformed_progress {
    Some(p) => Some(self.sample_progress(p))
    None => None
  }
}
