///|
/// CSS display property
#derive(Debug, Eq)
pub(all) enum Display {
  Block
  Inline
  InlineBlock
  Flex
  InlineFlex
  Grid
  InlineGrid
  Table
  InlineTable
  TableRow
  TableCell
  TableCaption
  TableRowGroup
  TableHeaderGroup
  TableFooterGroup
  TableColumn
  TableColumnGroup
  None
  Contents
  FlowRoot
}

///|
pub extend Display with @debug.Debug::{to_repr}

///|
pub extend Display with Eq::{not_equal, equal}

///|
/// CSS position property
#derive(Debug, Eq)
pub(all) enum Position {
  Static
  Relative
  Absolute
  Fixed
}

///|
pub extend Position with @debug.Debug::{to_repr}

///|
pub extend Position with Eq::{not_equal, equal}

///|
/// Flex direction
#derive(Debug, Eq)
pub(all) enum FlexDirection {
  Row
  RowReverse
  Column
  ColumnReverse
}

///|
pub extend FlexDirection with @debug.Debug::{to_repr}

///|
pub extend FlexDirection with Eq::{not_equal, equal}

///|
/// Alignment for justify-content, align-items, etc.
#derive(Debug, Eq)
pub(all) enum Alignment {
  Start
  End
  Left
  Right
  FlexStart
  FlexEnd
  Center
  SpaceBetween
  SpaceAround
  SpaceEvenly
  Stretch
  Baseline
}

///|
pub extend Alignment with @debug.Debug::{to_repr}

///|
pub extend Alignment with Eq::{not_equal, equal}

///|
/// Flex wrap mode
#derive(Debug, Eq)
pub(all) enum FlexWrap {
  NoWrap
  Wrap
  WrapReverse
}

///|
pub extend FlexWrap with @debug.Debug::{to_repr}

///|
pub extend FlexWrap with Eq::{not_equal, equal}

///|
/// Align-self value (can override align-items for individual items)
#derive(Debug, Eq)
pub(all) enum AlignSelf {
  Auto
  Start
  End
  Center
  Stretch
  Baseline
}

///|
pub extend AlignSelf with @debug.Debug::{to_repr}

///|
pub extend AlignSelf with Eq::{not_equal, equal}

///|
/// CSS float property
#derive(Debug, Eq)
pub(all) enum CssFloat {
  None
  Left
  Right
}

///|
pub extend CssFloat with @debug.Debug::{to_repr}

///|
pub extend CssFloat with Eq::{not_equal, equal}

///|
/// CSS clear property
#derive(Debug, Eq)
pub(all) enum Clear {
  None
  Left
  Right
  Both
}

///|
pub extend Clear with @debug.Debug::{to_repr}

///|
pub extend Clear with Eq::{not_equal, equal}

///|
/// CSS overflow property
#derive(Debug, Eq)
pub(all) enum Overflow {
  Visible
  Hidden
  Clip
  Scroll
  Auto
}

///|
pub extend Overflow with @debug.Debug::{to_repr}

///|
pub extend Overflow with Eq::{not_equal, equal}

///|
/// CSS box-sizing property
#derive(Debug, Eq)
pub(all) enum BoxSizing {
  ContentBox
  BorderBox
}

///|
pub extend BoxSizing with @debug.Debug::{to_repr}

///|
pub extend BoxSizing with Eq::{not_equal, equal}

///|
/// Grid auto-flow direction
#derive(Debug, Eq)
pub(all) enum GridAutoFlow {
  Row
  Column
  RowDense
  ColumnDense
}

///|
pub extend GridAutoFlow with @debug.Debug::{to_repr}

///|
pub extend GridAutoFlow with Eq::{not_equal, equal}

///|
/// Kind of a grid template axis (grid-template-columns / -rows).
/// `Explicit` is the normal `<track-list>` (or `none` when the track array is
/// empty); `Subgrid` / `Masonry` are the alternative axis values.
#derive(Debug, Eq)
pub(all) enum GridTemplateKind {
  Explicit
  Subgrid
  Masonry
}

///|
pub extend GridTemplateKind with @debug.Debug::{to_repr}

///|
pub extend GridTemplateKind with Eq::{not_equal, equal}

///|
/// `animation-direction` value.
#derive(Debug, Eq)
pub(all) enum AnimationDirection {
  Normal
  Reverse
  Alternate
  AlternateReverse
}

///|
pub extend AnimationDirection with @debug.Debug::{to_repr}

///|
pub extend AnimationDirection with Eq::{not_equal, equal}

///|
/// `animation-fill-mode` value.
#derive(Debug, Eq)
pub(all) enum AnimationFillMode {
  None
  Forwards
  Backwards
  Both
}

///|
pub extend AnimationFillMode with @debug.Debug::{to_repr}

///|
pub extend AnimationFillMode with Eq::{not_equal, equal}

///|
/// `animation-play-state` value.
#derive(Debug, Eq)
pub(all) enum AnimationPlayState {
  Running
  Paused
}

///|
pub extend AnimationPlayState with @debug.Debug::{to_repr}

///|
pub extend AnimationPlayState with Eq::{not_equal, equal}

///|
/// `animation-iteration-count` value (`<number>` or `infinite`).
#derive(Debug, Eq)
pub(all) enum AnimationIterationCount {
  Count(Double)
  Infinite
}

///|
pub extend AnimationIterationCount with @debug.Debug::{to_repr}

///|
pub extend AnimationIterationCount with Eq::{not_equal, equal}

///|
pub impl Show for AnimationDirection with fn output(self, logger) {
  let name = match self {
    Normal => "Normal"
    Reverse => "Reverse"
    Alternate => "Alternate"
    AlternateReverse => "AlternateReverse"
  }
  logger.write_string(name)
}

///|
pub extend AnimationDirection with Show::{to_string, output}

///|
pub impl Show for AnimationFillMode with fn output(self, logger) {
  let name = match self {
    None => "None"
    Forwards => "Forwards"
    Backwards => "Backwards"
    Both => "Both"
  }
  logger.write_string(name)
}

///|
pub extend AnimationFillMode with Show::{to_string, output}

///|
pub impl Show for AnimationPlayState with fn output(self, logger) {
  let name = match self {
    Running => "Running"
    Paused => "Paused"
  }
  logger.write_string(name)
}

///|
pub extend AnimationPlayState with Show::{to_string, output}

///|
pub impl Show for AnimationIterationCount with fn output(self, logger) {
  match self {
    Count(v) => logger.write_string("Count(\{v})")
    Infinite => logger.write_string("Infinite")
  }
}

///|
pub extend AnimationIterationCount with Show::{to_string, output}

///|
/// Grid line placement for grid items
#derive(Debug, Eq)
pub(all) enum GridPlacement {
  Auto
  Line(Int32)
  Span(Int32)
  // Named line reference, e.g. `grid-column: left-sidebar`.
  // Resolved against the named lines declared in grid-template-columns/rows.
  Named(String)
  // `<integer> && <custom-ident>`, e.g. `grid-column: 2 foo`: the Nth line
  // named `foo` (N may be negative to count from the end).
  NamedLine(Int32, String)
  // `span && <integer>? && <custom-ident>`, e.g. `grid-column: span 2 foo`:
  // span until the Nth line named `foo` (N defaults to 1).
  SpanNamed(Int32, String)
}

///|
pub extend GridPlacement with @debug.Debug::{to_repr}

///|
pub extend GridPlacement with Eq::{not_equal, equal}

///|
/// Single track sizing function (non-repeating)
#derive(Debug, Eq)
pub(all) enum SingleTrackSizing {
  Length(Double)
  Percent(Double)
  Fr(Double)
  Auto
  MinContent
  MaxContent
  MinMax(MinTrackSizing, MaxTrackSizing)
  FitContentLength(Double)
  FitContentPercent(Double)
}

///|
pub extend SingleTrackSizing with @debug.Debug::{to_repr}

///|
pub extend SingleTrackSizing with Eq::{not_equal, equal}

///|
/// Repeat count for repeat() function
#derive(Debug, Eq)
pub(all) enum RepeatCount {
  Count(Int32)
  AutoFill
  AutoFit
}

///|
pub extend RepeatCount with @debug.Debug::{to_repr}

///|
pub extend RepeatCount with Eq::{not_equal, equal}

///|
/// Track sizing function for grid-template-rows/columns
#derive(Debug, Eq)
pub(all) enum TrackSizingFunction {
  Length(Double)
  Percent(Double)
  Fr(Double)
  Auto
  MinContent
  MaxContent
  MinMax(MinTrackSizing, MaxTrackSizing)
  // Repeat(count, tracks, line_names). `line_names` holds the named lines
  // declared inside one repetition (index = line within the repetition, length
  // = tracks + 1), e.g. `repeat(3, [a] 1fr [b])` => [["a"], ["b"]].
  Repeat(RepeatCount, Array[SingleTrackSizing], Array[Array[String]])
  FitContentLength(Double)
  FitContentPercent(Double)
}

///|
pub extend TrackSizingFunction with @debug.Debug::{to_repr}

///|
pub extend TrackSizingFunction with Eq::{not_equal, equal}

///|
/// Minimum track sizing function for minmax()
#derive(Debug, Eq)
pub(all) enum MinTrackSizing {
  Length(Double)
  Percent(Double)
  Auto
  MinContent
  MaxContent
}

///|
pub extend MinTrackSizing with @debug.Debug::{to_repr}

///|
pub extend MinTrackSizing with Eq::{not_equal, equal}

///|
/// Maximum track sizing function for minmax()
#derive(Debug, Eq)
pub(all) enum MaxTrackSizing {
  Length(Double)
  Percent(Double)
  Fr(Double)
  Auto
  MinContent
  MaxContent
}

///|
pub extend MaxTrackSizing with @debug.Debug::{to_repr}

///|
pub extend MaxTrackSizing with Eq::{not_equal, equal}

///|
/// Grid line range (start and end)
#derive(Debug, Eq)
pub(all) struct GridLine {
  start : GridPlacement
  end : GridPlacement
}

///|
pub extend GridLine with @debug.Debug::{to_repr}

///|
pub extend GridLine with Eq::{not_equal, equal}

///|
let grid_line_auto : GridLine = { start: Auto, end: Auto, }

///|
pub fn GridLine::auto() -> GridLine {
  grid_line_auto
}

///|
pub impl Show for Display with fn output(self, logger) {
  let name = match self {
    Block => "Block"
    Inline => "Inline"
    InlineBlock => "InlineBlock"
    Flex => "Flex"
    InlineFlex => "InlineFlex"
    Grid => "Grid"
    InlineGrid => "InlineGrid"
    Table => "Table"
    InlineTable => "InlineTable"
    TableRow => "TableRow"
    TableCell => "TableCell"
    TableCaption => "TableCaption"
    TableRowGroup => "TableRowGroup"
    TableHeaderGroup => "TableHeaderGroup"
    TableFooterGroup => "TableFooterGroup"
    TableColumn => "TableColumn"
    TableColumnGroup => "TableColumnGroup"
    None => "None"
    Contents => "Contents"
    FlowRoot => "FlowRoot"
  }
  logger.write_string(name)
}

///|
pub extend Display with Show::{to_string, output}

///|
pub impl Show for Position with fn output(self, logger) {
  let name = match self {
    Static => "Static"
    Relative => "Relative"
    Absolute => "Absolute"
    Fixed => "Fixed"
  }
  logger.write_string(name)
}

///|
pub extend Position with Show::{to_string, output}

///|
pub impl Show for FlexDirection with fn output(self, logger) {
  let name = match self {
    Row => "Row"
    RowReverse => "RowReverse"
    Column => "Column"
    ColumnReverse => "ColumnReverse"
  }
  logger.write_string(name)
}

///|
pub extend FlexDirection with Show::{to_string, output}

///|
pub impl Show for Alignment with fn output(self, logger) {
  let name = match self {
    Start => "Start"
    End => "End"
    Left => "Left"
    Right => "Right"
    FlexStart => "FlexStart"
    FlexEnd => "FlexEnd"
    Center => "Center"
    SpaceBetween => "SpaceBetween"
    SpaceAround => "SpaceAround"
    SpaceEvenly => "SpaceEvenly"
    Stretch => "Stretch"
    Baseline => "Baseline"
  }
  logger.write_string(name)
}

///|
pub extend Alignment with Show::{to_string, output}

///|
pub impl Show for FlexWrap with fn output(self, logger) {
  let name = match self {
    NoWrap => "NoWrap"
    Wrap => "Wrap"
    WrapReverse => "WrapReverse"
  }
  logger.write_string(name)
}

///|
pub extend FlexWrap with Show::{to_string, output}

///|
pub impl Show for AlignSelf with fn output(self, logger) {
  let name = match self {
    Auto => "Auto"
    Start => "Start"
    End => "End"
    Center => "Center"
    Stretch => "Stretch"
    Baseline => "Baseline"
  }
  logger.write_string(name)
}

///|
pub extend AlignSelf with Show::{to_string, output}

///|
pub impl Show for CssFloat with fn output(self, logger) {
  let name = match self {
    None => "None"
    Left => "Left"
    Right => "Right"
  }
  logger.write_string(name)
}

///|
pub extend CssFloat with Show::{to_string, output}

///|
pub impl Show for Clear with fn output(self, logger) {
  let name = match self {
    None => "None"
    Left => "Left"
    Right => "Right"
    Both => "Both"
  }
  logger.write_string(name)
}

///|
pub extend Clear with Show::{to_string, output}

///|
pub impl Show for Overflow with fn output(self, logger) {
  let name = match self {
    Visible => "Visible"
    Hidden => "Hidden"
    Clip => "Clip"
    Scroll => "Scroll"
    Auto => "Auto"
  }
  logger.write_string(name)
}

///|
pub extend Overflow with Show::{to_string, output}

///|
pub impl Show for BoxSizing with fn output(self, logger) {
  let name = match self {
    ContentBox => "ContentBox"
    BorderBox => "BorderBox"
  }
  logger.write_string(name)
}

///|
pub extend BoxSizing with Show::{to_string, output}

///|
pub impl Show for GridAutoFlow with fn output(self, logger) {
  let name = match self {
    Row => "Row"
    Column => "Column"
    RowDense => "RowDense"
    ColumnDense => "ColumnDense"
  }
  logger.write_string(name)
}

///|
pub extend GridAutoFlow with Show::{to_string, output}

///|
pub impl Show for GridTemplateKind with fn output(self, logger) {
  let name = match self {
    Explicit => "Explicit"
    Subgrid => "Subgrid"
    Masonry => "Masonry"
  }
  logger.write_string(name)
}

///|
pub extend GridTemplateKind with Show::{to_string, output}

///|
pub impl Show for GridPlacement with fn output(self, logger) {
  let text = match self {
    Auto => "Auto"
    Line(v) => "Line(\{v})"
    Span(v) => "Span(\{v})"
    Named(name) => "Named(\{name})"
    NamedLine(n, name) => "NamedLine(\{n}, \{name})"
    SpanNamed(n, name) => "SpanNamed(\{n}, \{name})"
  }
  logger.write_string(text)
}

///|
pub extend GridPlacement with Show::{to_string, output}

///|
pub impl Show for SingleTrackSizing with fn output(self, logger) {
  let text = match self {
    Length(v) => "Length(\{v})"
    Percent(v) => "Percent(\{v})"
    Fr(v) => "Fr(\{v})"
    Auto => "Auto"
    MinContent => "MinContent"
    MaxContent => "MaxContent"
    MinMax(min, max) => "MinMax(\{min}, \{max})"
    FitContentLength(v) => "FitContentLength(\{v})"
    FitContentPercent(v) => "FitContentPercent(\{v})"
  }
  logger.write_string(text)
}

///|
pub extend SingleTrackSizing with Show::{to_string, output}

///|
pub impl Show for RepeatCount with fn output(self, logger) {
  let text = match self {
    Count(v) => "Count(\{v})"
    AutoFill => "AutoFill"
    AutoFit => "AutoFit"
  }
  logger.write_string(text)
}

///|
pub extend RepeatCount with Show::{to_string, output}

///|
pub impl Show for TrackSizingFunction with fn output(self, logger) {
  let text = match self {
    Length(v) => "Length(\{v})"
    Percent(v) => "Percent(\{v})"
    Fr(v) => "Fr(\{v})"
    Auto => "Auto"
    MinContent => "MinContent"
    MaxContent => "MaxContent"
    MinMax(min, max) => "MinMax(\{min}, \{max})"
    Repeat(count, tracks, line_names) => {
      // Only render the line-name component when at least one line is named, so
      // plain repeats keep the compact two-argument form.
      let mut has_names = false
      for g in line_names {
        if g.length() > 0 {
          has_names = true
          break
        }
      }
      if has_names {
        "Repeat(\{count}, \{@debug.Repr(tracks)}, \{@debug.Repr(line_names)})"
      } else {
        "Repeat(\{count}, \{@debug.Repr(tracks)})"
      }
    }
    FitContentLength(v) => "FitContentLength(\{v})"
    FitContentPercent(v) => "FitContentPercent(\{v})"
  }
  logger.write_string(text)
}

///|
pub extend TrackSizingFunction with Show::{to_string, output}

///|
pub impl Show for MinTrackSizing with fn output(self, logger) {
  let text = match self {
    Length(v) => "Length(\{v})"
    Percent(v) => "Percent(\{v})"
    Auto => "Auto"
    MinContent => "MinContent"
    MaxContent => "MaxContent"
  }
  logger.write_string(text)
}

///|
pub extend MinTrackSizing with Show::{to_string, output}

///|
pub impl Show for MaxTrackSizing with fn output(self, logger) {
  let text = match self {
    Length(v) => "Length(\{v})"
    Percent(v) => "Percent(\{v})"
    Fr(v) => "Fr(\{v})"
    Auto => "Auto"
    MinContent => "MinContent"
    MaxContent => "MaxContent"
  }
  logger.write_string(text)
}

///|
pub extend MaxTrackSizing with Show::{to_string, output}

///|
pub impl Show for GridLine with fn output(self, logger) {
  logger.write_string("{start: ")
  logger.write_string(self.start.to_string())
  logger.write_string(", end: ")
  logger.write_string(self.end.to_string())
  logger.write_string("}")
}

///|
pub extend GridLine with Show::{to_string, output}
