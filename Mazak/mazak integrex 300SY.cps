/**
  Copyright (C) 2012-2018 by Autodesk, Inc.
  All rights reserved.

  Mazak Integrex post processor configuration.

  $Revision: 42380 94d0f99908c1d4e7cabeeb9bf7c83bb04d7aae8b $
  $Date: 2019-07-12 11:58:47 $

  FORKID {62F61C65-979D-4f9f-97B0-C5F9634CC6A7}
*/

///////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     useXZCMode                 - Force XZC mode for next operation
//     usePolarMode               - Force Polar mode for next operation
//
///////////////////////////////////////////////////////////////////////////////

description = "Werkzeugbaumueller GmbH - Fraesdrehzentrum";
vendor = "Mazak";
model = "Integrex 300SY"
vendorUrl = "https://www.mazak.com";
legal = "Copyright (C) 2012-2018 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 40783;

longDescription = "Generic mill-turn post for Mazak Integrex machines. This post required machine specific customization for production use! Use the tool product ID to specify the ID Code for the tools.";

extension = "eia";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = false;
highFeedrate = (unit == IN) ? 400 : 5000;

// user-defined properties
properties = {
  writeMachine: true, // write machine
  writeTools: true, // writes the tools
  preloadTool: true, // preloads next tool on tool change if any
  showSequenceNumbers: false, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 10, // increment for sequence numbers
  sequenceNumberOnlyOnToolChange: false, // only output sequence numbers on tool change
  numberOfToolDigits: 2, // Number of tool digites, can be 2 or 3 (T01 or T001)
  //optionalStop: true, // optional stop
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: true, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  maximumSpindleSpeed: 3500, // specifies the maximum spindle speed
  useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: true, // specifies that operation notes should be output.
  useCycles: false, // specifies that drilling cycles should be used.
  useSmoothing: false, // specifies if smoothing should be used or not
  g53HomePositionX: 0.0, // home position for X-axis
  g53HomePositionY: 0.0, // home position for Y-axis
  g53HomePositionZ: 0.0, // home position for Z-axis
  g53HomePositionSubZ: 0.0 // home Position for Z when the operation uses the secondary spindle
};

// user-defined property definitions
propertyDefinitions = {
  writeMachine: { title: "Write machine", description: "Output the machine settings in the header of the code.", group: 0, type: "boolean" },
  writeTools: { title: "Write tool list", description: "Output a tool list in the header of the code.", group: 0, type: "boolean" },
  preloadTool: { title: "Preload tool", description: "Preloads the next tool at a tool change (if any).", type: "boolean" },
  showSequenceNumbers: { title: "Use sequence numbers", description: "Use sequence numbers for each block of outputted code.", group: 1, type: "boolean" },
  sequenceNumberStart: { title: "Start sequence number", description: "The number at which to start the sequence numbers.", group: 1, type: "integer" },
  sequenceNumberIncrement: { title: "Sequence number increment", description: "The amount by which the sequence number is incremented by in each block.", group: 1, type: "integer" },
  sequenceNumberOnlyOnToolChange: { title: "Sequence number only on tool change", description: "If enabled, sequence numbers are only outputted when a toolchange is called", type: "boolean" },
  numberOfToolDigits: { title: "Tool digits", description: "Number of digits used for a tool call. Can be 2 or 3 i.e. T01 or T001", group: 1, type: "integer" },
  //optionalStop: {title:"Optional stop", description:"Outputs optional stop code during when necessary in the code.", type:"boolean"},
  separateWordsWithSpace: { title: "Separate words with space", description: "Adds spaces between words if 'yes' is selected.", type: "boolean" },
  useRadius: { title: "Radius arcs", description: "If yes is selected, arcs are outputted using radius values rather than IJK.", type: "boolean" },
  maximumSpindleSpeed: { title: "Max spindle speed", description: "Defines the maximum spindle speed allowed by your machines.", type: "integer", range: [0, 999999999] },
  useParametricFeed: { title: "Parametric feed", description: "Specifies the feed value that should be output using a Q value.", type: "boolean" },
  showNotes: { title: "Show notes", description: "Writes operation notes as comments in the outputted code.", type: "boolean" },
  useCycles: { title: "Use cycles", description: "Specifies if canned drilling cycles should be used.", type: "boolean" },
  useSmoothing: { title: "Use smoothing", description: "Specifies if smoothing should be used or not.", type: "boolean" },
  g53HomePositionX: { title: "G53 home position X", description: "G53 X-axis home position.", type: "number" },
  g53HomePositionY: { title: "G53 home position Y", description: "G53 Y-axis home position.", type: "number" },
  g53HomePositionZ: { title: "G53 home position Z", description: "G53 Z-axis home position.", type: "number" },
  g53HomePositionSubZ: { title: "G53 home position Z (secondary spindle)", description: "G53 Z-axis home position for the secondary spindle.", type: "number" }
};

// samples:
// throughTool: {on: 88, off: 89}
// throughTool: {on: [8, 88], off: [9, 89]}
var coolants = {
  flood: { turret1: { on: 8, off: 9 }, turret2: { on: 8, off: 9 } },
  mist: { turret1: {}, turret2: {} },
  throughTool: { turret1: { on: 153, off: 154 }, turret2: { on: 153, off: 154 } },
  air: { turret1: {}, turret2: {} },
  airThroughTool: { turret1: { on: 151, off: 152 }, turret2: {} },
  suction: { turret1: {}, turret2: {} },
  floodMist: { turret1: {}, turret2: {} },
  floodThroughTool: {},
  off: 9
};

var writeDebug = true; // specifies to output debug information

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({ prefix: "G", decimals: 1 });
var mFormat = createFormat({ prefix: "M", decimals: 0 });

var spatialFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var xFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 2 }); // diameter mode & IS SCALING POLAR COORDINATES
var yFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var zFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var rFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true }); // radius
var abcFormat = createFormat({ decimals: 4, forceDecimal: true, scale: DEG });
var cFormat = createFormat({ decimals: 4, forceDecimal: true, scale: DEG });
var feedFormat = createFormat({ decimals: (unit == MM ? 2 : 3), forceDecimal: true });
var pitchFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var rpmFormat = createFormat({ decimals: 0 });
var milliFormat = createFormat({ decimals: 0 }); // milliseconds // range 1-99999999
var taperFormat = createFormat({ decimals: 1, scale: DEG });

var xOutput = createVariable({ onchange: function () { retracted = false; }, prefix: "X" }, xFormat);
var yOutput = createVariable({ prefix: "Y" }, yFormat);
var zOutput = createVariable({ onchange: function () { retracted = false; }, prefix: "Z" }, zFormat);
var aOutput = createVariable({ prefix: "A" }, abcFormat);
var bOutput = createVariable({ prefix: "B" }, abcFormat);
var cOutput = createVariable({ prefix: "C" }, cFormat);
var feedOutput = createVariable({ prefix: "F" }, feedFormat);
var pitchOutput = createVariable({ prefix: "F", force: true }, pitchFormat);
var sOutput = createVariable({ prefix: "S", force: true }, rpmFormat);

// circular output
var iOutput = createReferenceVariable({ prefix: "I", force: true }, spatialFormat);
var jOutput = createReferenceVariable({ prefix: "J", force: true }, spatialFormat);
var kOutput = createReferenceVariable({ prefix: "K", force: true }, spatialFormat);

var g92IOutput = createVariable({ prefix: "I" }, zFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({ onchange: function () { gMotionModal.reset(); } }, gFormat); // modal group 2 // G17-19
var gFeedModeModal = createModal({}, gFormat);
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gPolarModal = createModal({}, gFormat); // G12.1, G13.1
var gCycleModal = gMotionModal;
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99
var gSpindleModal = createModal({}, gFormat);
var cAxisEngageModal = createModal({}, mFormat);
var tailStockModal = createModal({}, mFormat);

// fixed settings
var firstFeedParameter = 105;
var g53HomePositionXParameter = 100;
var g53HomePositionZParameter = 101;
var g53HomePositionYParameter = 102;
var g53HomePositionSubZParameter = 103;
var gotYAxis = true;
var yAxisMinimum = toPreciseUnit(gotYAxis ? -105 : 0, MM); // specifies the minimum range for the Y-axis
var yAxisMaximum = toPreciseUnit(gotYAxis ? 105 : 0, MM); // specifies the maximum range for the Y-axis
var xAxisMinimum = toPreciseUnit(-20, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)

var gotPolarInterpolation = false; // specifies if the machine has XY polar interpolation (G112) capabilities
var gotBAxis = true;
var useMultiAxisFeatures = false;
var gotSecondarySpindle = true;
var gotMultiTurret = false; // specifies if the machine has several turrets
var gotTailStock = false;

var WARNING_WORK_OFFSET = 0;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var forcePolarMode = true; // force Polar output, activated by Action:usePolarMode
var forceXZCMode = false; // forces XZC output, activated by Action:useXZCMode
var maximumCircularRadiiDifference = toPreciseUnit(0.005, MM);
var bestABCIndex = undefined;
var retracted = false; // specifies that the tool has been retracted to the safe plane

var machineState = {
  liveToolIsActive: undefined,
  cAxisIsEngaged: undefined,
  machiningDirection: undefined,
  mainSpindleIsActive: undefined,
  subSpindleIsActive: undefined,
  mainSpindleBrakeIsActive: undefined,
  subSpindleBrakeIsActive: undefined,
  tailstockIsActive: undefined,
  usePolarMode: undefined,
  useXZCMode: undefined,
  axialCenterDrilling: undefined,
  tapping: undefined,
  feedPerRevolution: undefined,
  currentBAxisOrientationTurning: new Vector(0, 0, 0),
  currentTurret: undefined
};

function writeDebugInfo(text) {
  if (writeDebug) {
    return formatComment(text);
  }
}

/** G/M codes setup. */
function getCode(code) {
  switch (code) {
    // case "PART_CATCHER_ON":
    // return mFormat.format(undefined);
    // case "PART_CATCHER_OFF":
    // return mFormat.format(undefined);
    // case "TAILSTOCK_ON":
    // machineState.tailstockIsActive = true;
    // return tailStockModal.format(undefined);
    // case "TAILSTOCK_OFF":
    // machineState.tailstockIsActive = false;
    // return tailStockModal.format(undefined);
    case "ENGAGE_C_AXIS":
      machineState.cAxisIsEngaged = true;
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        return combineCommands(cAxisEngageModal.format(200), writeDebugInfo("Milling mode main spindle"));
      } else {
        return combineCommands(gFormat.format(112), cAxisEngageModal.format(200), writeDebugInfo("Milling mode sub-spindle"));
      }
    case "DISENGAGE_C_AXIS":
      machineState.cAxisIsEngaged = false;
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        return combineCommands(cAxisEngageModal.format(202), writeDebugInfo("Main spindle lathe mode"));
      } else {
        return combineCommands(gFormat.format(112), cAxisEngageModal.format(202), writeDebugInfo("Sub-spindle lathe mode"));
      }
    case "POLAR_INTERPOLATION_ON":
      return gPolarModal.format(12.1);
    case "POLAR_INTERPOLATION_OFF":
      return gPolarModal.format(13.1);
    case "STOP_LIVE_TOOL":
      machineState.liveToolIsActive = false;
      return combineCommands(mFormat.format(205), writeDebugInfo("Stop live tool"));
    case "STOP_MAIN_SPINDLE":
      machineState.mainSpindleIsActive = false;
      return combineCommands(mFormat.format(5), writeDebugInfo("Stop main spindle"));
    case "STOP_SUB_SPINDLE":
      machineState.subSpindleIsActive = false;
      return combineCommands(gFormat.format(112), mFormat.format(5), writeDebugInfo("Stop sub-spindle"));
    case "UNLOCK_MILLING_SPINDLE":
      machineState.millingSpindleLocked = false;
      return combineCommands(mFormat.format(252), writeDebugInfo("Unlock milling spindle"));
    case "LOCK_MILLING_SPINDLE":
      machineState.millingSpindleLocked = true;
      return combineCommands(mFormat.format(253), writeDebugInfo("Lock milling spindle"));
    case "START_LIVE_TOOL_CW":
      machineState.liveToolIsActive = true;
      return combineCommands(mFormat.format(203), writeDebugInfo("Start live tool CW"));
    case "START_LIVE_TOOL_CCW":
      machineState.liveToolIsActive = true;
      return combineCommands(mFormat.format(204), writeDebugInfo("Start live tool CCW"));
    case "START_MAIN_SPINDLE_CW":
      machineState.mainSpindleIsActive = true;
      return combineCommands(mFormat.format(3), writeDebugInfo("Start main spindle CW"));
    case "START_MAIN_SPINDLE_CCW":
      machineState.mainSpindleIsActive = true;
      return combineCommands(mFormat.format(4), writeDebugInfo("Start main spindle CCW"));
    case "START_SUB_SPINDLE_CW":
      machineState.subSpindleIsActive = true;
      return combineCommands(gFormat.format(112), mFormat.format(3), writeDebugInfo("Start sub spindle CW"));
    case "START_SUB_SPINDLE_CCW":
      machineState.subSpindleIsActive = true;
      return combineCommands(gFormat.format(112), mFormat.format(4), writeDebugInfo("Start sub spindle CCW"));
    case "MAIN_SPINDLE_BRAKE_ON":
      machineState.mainSpindleBrakeIsActive = true;
      return cAxisBrakeModal.format(14);
    case "MAIN_SPINDLE_BRAKE_OFF":
      machineState.mainSpindleBrakeIsActive = false;
      return cAxisBrakeModal.format(15);
    case "SUB_SPINDLE_BRAKE_ON":
      machineState.subSpindleBrakeIsActive = true;
      return cAxisBrakeModal.format(114);
    case "SUB_SPINDLE_BRAKE_OFF":
      machineState.subSpindleBrakeIsActive = false;
      return cAxisBrakeModal.format(115);
    case "FEED_MODE_UNIT_REV":
      machineState.feedPerRevolution = true;
      return combineCommands(gFeedModeModal.format(95), writeDebugInfo("Synchronous feed"));
    case "FEED_MODE_UNIT_MIN":
      machineState.feedPerRevolution = false;
      return combineCommands(gFeedModeModal.format(94), writeDebugInfo("Asynchronous feed"));
    case "CONSTANT_SURFACE_SPEED_ON":
      return combineCommands(gSpindleModeModal.format(96), writeDebugInfo("Constant surface speed"));
    case "CONSTANT_SURFACE_SPEED_OFF":
      return combineCommands(gSpindleModeModal.format(97), writeDebugInfo("Cancel constant surface speed"));
    case "CLAMP_B_AXIS":
      return combineCommands(mFormat.format(251), writeDebugInfo("B-axis clamp"));
    case "UNCLAMP_B_AXIS":
      return combineCommands(mFormat.format(250), writeDebugInfo("B-axis unclamp"));
    case "CLAMP_PRIMARY_SPINDLE":
      return combineCommands(mFormat.format(210), writeDebugInfo("Clamp main spindle"));
    case "UNCLAMP_PRIMARY_SPINDLE":
      return combineCommands(mFormat.format(212), writeDebugInfo("Unclamp main spindle"));
    case "CLAMP_SECONDARY_SPINDLE":
      return combineCommands(gFormat.format(112), mFormat.format(210), writeDebugInfo("Clamp sub spindle"));
    case "UNCLAMP_SECONDARY_SPINDLE":
      return combineCommands(gFormat.format(112), mFormat.format(212), writeDebugInfo("Unclamp sub spindle"));
    // case "SPINDLE_SYNCHRONIZATION_ON":
    // machineState.spindleSynchronizationIsActive = true;
    // return gSynchronizedSpindleModal.format(undefined);
    // case "SPINDLE_SYNCHRONIZATION_OFF":
    // machineState.spindleSynchronizationIsActive = false;
    // return gSynchronizedSpindleModal.format(undefined);
    // case "START_CHIP_TRANSPORT":
    // return mFormat.format(undefined);
    // case "STOP_CHIP_TRANSPORT":
    // return mFormat.format(undefined);
    // case "OPEN_DOOR":
    // return mFormat.format(undefined);
    // case "CLOSE_DOOR":
    // return mFormat.format(undefined);
    // case "MAINSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(undefined);
    // case "MAINSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(undefined);
    // case "SUBSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(undefined);
    // case "SUBSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(undefined);
    default:
      error(localize("Command " + code + " is not defined."));
      return 0;
  }
}

function isSpindleSpeedDifferent() {
  if (isFirstSection()) {
    return true;
  }
  if (getPreviousSection().getTool().clockwise != tool.clockwise) {
    return true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SURFACE_SPEED) ||
      rpmFormat.areDifferent(getPreviousSection().getTool().surfaceSpeed, tool.surfaceSpeed)) {
      return true;
    }
  } else {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
      rpmFormat.areDifferent(getPreviousSection().getTool().spindleRPM, spindleSpeed)) {
      return true;
    }
  }
  return false;
}

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) {
    startSpindle(false, getFramePosition(currentSection.getInitialPosition()), spindleSpeed);
  }
}

function startSpindle(forceRPMMode, initialPosition, rpm) {
  var useConstantSurfaceSpeed = currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED;
  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }

  gSpindleModeModal.reset();
  var spindleMode;
  if (useConstantSurfaceSpeed && !forceRPMMode) {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON");
  } else {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
  }

  _spindleSpeed = useConstantSurfaceSpeed ? tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0) : _spindleSpeed;
  if (useConstantSurfaceSpeed && forceRPMMode) { // RPM mode is forced until move to initial position
    if (xFormat.getResultingValue(initialPosition.x) == 0) {
      _spindleSpeed = maximumSpindleSpeed;
    } else {
      _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
    }
  }
  switch (currentSection.spindle) {
    case SPINDLE_PRIMARY: // main spindle
      if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
        gSpindleModeModal.reset();
        sOutput.reset();
        if (useConstantSurfaceSpeed && !forceRPMMode) {
          writeBlock(gFormat.format(92), sOutput.format(maximumSpindleSpeed), "R1", writeDebugInfo("Maxium speed spindle 1")); // spindle 1 is the default;
        }
        writeBlock(
          spindleMode,
          sOutput.format(_spindleSpeed),
          tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW")
        ); // R1 is the default
        sOutput.reset();
      } else {
        writeBlock(getCode("CONSTANT_SURFACE_SPEED_OFF"), sOutput.format(_spindleSpeed), tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"));
      }
      break;
    case SPINDLE_SECONDARY: // sub spindle
      if (!gotSecondarySpindle) {
        error(localize("Secondary spindle is not available."));
        return;
      }
      if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
        gSpindleModeModal.reset();
        sOutput.reset();
        if (useConstantSurfaceSpeed && !forceRPMMode) {
          writeBlock(gFormat.format(92), sOutput.format(maximumSpindleSpeed), "R2", writeDebugInfo("Maxiumum speed spindle 2")); // spindle 1 is the default;
        }
        writeBlock(
          spindleMode,
          sOutput.format(_spindleSpeed),
          tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW")
        ); // R1 is the default
        sOutput.reset();
      } else {
        writeBlock(spindleMode, sOutput.format(_spindleSpeed), tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"));
      }
      break;
  }
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  var words = []; // store all retracted axes in an array
  for (var i = 0; i < arguments.length; ++i) {
    let instances = 0; // checks for duplicate retract calls
    for (var j = 0; j < arguments.length; ++j) {
      if (arguments[i] == arguments[j]) {
        ++instances;
      }
    }
    if (instances > 1) { // error if there are multiple retract calls for the same axis
      error(localize("Cannot retract the same axis twice in one line"));
      return;
    }
    switch (arguments[i]) {
      case X:
        xOutput.reset();
        words.push("X#" + g53HomePositionXParameter);
        retracted = true; // specifies that the tool has been retracted to the safe plane
        break;
      case Y:
        if (gotYAxis) {
          yOutput.reset();
          words.push("Y#" + g53HomePositionYParameter);
        }
        break;
      case Z:
        zOutput.reset();
        words.push("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? g53HomePositionSubZParameter : g53HomePositionZParameter));
        retracted = true; // specifies that the tool has been retracted to the safe plane
        break;
      default:
        error(localize("Bad axis specified for writeRetract()."));
        return;
    }
  }
  gMotionModal.reset();
  if (words.length > 0) {
    writeBlock(gAbsIncModal.format(90), gMotionModal.format(0), gFormat.format(53), words); // retract
  }
  forceXYZ();
}

/** Returns the modulus. */
function getModulus(x, y) {
  return Math.sqrt(x * x + y * y);
}

/**
  Returns the C rotation for the given X and Y coordinates.
*/
function getC(x, y) {
  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  return Math.atan2(y, x) * direction;
}

/**
  Returns the C rotation for the given X and Y coordinates in the desired rotary direction.
*/
function getCClosest(x, y, _c, clockwise) {
  if (_c == Number.POSITIVE_INFINITY) {
    _c = 0; // undefined
  }
  if (!xFormat.isSignificant(x) && !yFormat.isSignificant(y)) { // keep C if XY is on center
    return _c;
  }
  var c = getC(x, y);
  if (clockwise != undefined) {
    if (clockwise) {
      while (c < _c) {
        c += Math.PI * 2;
      }
    } else {
      while (c > _c) {
        c -= Math.PI * 2;
      }
    }
  } else {
    min = _c - Math.PI;
    max = _c + Math.PI;
    while (c < min) {
      c += Math.PI * 2;
    }
    while (c > max) {
      c -= Math.PI * 2;
    }
  }
  return c;
}

function getCWithinRange(x, y, _c, clockwise) {
  var c = getCClosest(x, y, _c, clockwise);

  var cyclicLimit;
  var cyclic;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the U-axis
    cyclicLimit = machineConfiguration.getAxisU().getRange();
    cyclic = machineConfiguration.getAxisU().isCyclic();
  } else if (Vector.dot(machineConfiguration.getAxisV().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the V-axis
    cyclicLimit = machineConfiguration.getAxisV().getRange();
    cyclic = machineConfiguration.getAxisV().isCyclic();
  } else {
    error(localize("Unsupported rotary axis direction."));
    return 0;
  }

  // see if rewind is required
  forceRewind = false;
  if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
    if (!cyclic) {
      forceRewind = true;
    }
    c = getCClosest(x, y, 0); // find closest C to 0
    if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
      var midRange = cyclicLimit[0] + (cyclicLimit[1] - cyclicLimit[0]) / 2;
      c = getCClosest(x, y, midRange); // find closest C to midRange
    }
    if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
      error(localize("Unable to find C-axis position within the defined range."));
      return 0;
    }
  }
  return c;
}

/**
  Returns the desired tolerance for the given section.
*/
function getTolerance() {
  var t = tolerance;
  if (hasParameter("operation:tolerance")) {
    if (t > 0) {
      t = Math.min(t, getParameter("operation:tolerance"));
    } else {
      t = getParameter("operation:tolerance");
    }
  }
  return t;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  if (properties.showSequenceNumbers && !properties.sequenceNumberOnlyOnToolChange) {
    if (optionalSection) {
      var text = formatWords(arguments);
      if (text) {
        writeWords("/", "N" + sequenceNumber, text);
      }
    } else {
      writeWords2("N" + sequenceNumber, arguments);
    }
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    if (optionalSection) {
      writeWords2("/", arguments);
    } else {
      writeWords(arguments);
    }
  }
}

/**
  Combine commands with a space.
*/
function combineCommands() {
  var args = Array.prototype.slice.call(arguments);
  return args.join(" ");
}

/**
  Writes the specified block - used for tool changes only.
*/
function writeToolBlock() {
  if (properties.showSequenceNumbers) {
    writeWords2("N" + sequenceNumber, arguments);
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    writeWords(arguments);
  }
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  if (properties.showSequenceNumbers) {
    var words = formatWords(arguments);
    if (words) {
      writeWords("/", "N" + sequenceNumber, words);
      sequenceNumber += properties.sequenceNumberIncrement;
    }
  } else {
    writeWords2("/", arguments);
  }
}

function formatComment(text) {
  return "(" + filterText(String(text).toUpperCase(), permittedCommentChars) + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

var machineConfigurationMainSpindle;
var machineConfigurationSubSpindle;

function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  if (true) {
    // make sure parameter F85 Bit 2 is set for 5 axis simultaneous
    var bAxisMain = createAxis({ coordinate: 1, table: false, axis: [0, -1, 0], range: [-30, 195], preference: 0 });
    var cAxisMain = createAxis({ coordinate: 2, table: true, axis: [0, 0, 1], range: [-360, 360], cyclic: true, preference: 0 });

    var bAxisSub = createAxis({ coordinate: 1, table: false, axis: [0, 1, 0], range: [-30, 195], preference: 0 });
    var cAxisSub = createAxis({ coordinate: 2, table: true, axis: [0, 0, -1], range: [-360, 360], cyclic: true, preference: 0 });

    machineConfigurationMainSpindle = gotBAxis ? new MachineConfiguration(bAxisMain, cAxisMain) : new MachineConfiguration(cAxisMain);
    machineConfigurationSubSpindle = gotBAxis ? new MachineConfiguration(bAxisSub, cAxisSub) : new MachineConfiguration(cAxisSub);
  }

  machineConfiguration = new MachineConfiguration(); // creates an empty configuration to be able to set eg vendor information

  if (!gotYAxis) {
    yOutput.disable();
  }
  aOutput.disable();
  if (!gotBAxis) {
    bOutput.disable();
  }

  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }

  sequenceNumber = properties.sequenceNumberStart;

  if (programName) {
    var programId;
    try {
      programId = getAsInt(programName);
    } catch (e) {
      error(localize("Program name must be a number."));
      return;
    }
    if (!((programId >= 1) && (programId <= 99999999))) {
      error(localize("Program number is out of range."));
      return;
    }
    var o4Format = createFormat({ width: 4, zeropad: true, decimals: 0 });
    var o8Format = createFormat({ width: 8, zeropad: true, decimals: 0 });
    var oFormat = (programId <= 9999) ? o4Format : o8Format;
    if (programComment) {
      writeln("O" + oFormat.format(programId) + " " + formatComment(programComment));
    } else {
      writeln("O" + oFormat.format(programId));
    }
  } else {
    error(localize("Program name has not been specified."));
    return;
  }

  // dump machine configuration
  // var vendor = machineConfiguration.getVendor();
  // var model = machineConfiguration.getModel();
  // var description = machineConfiguration.getDescription();

  if (properties.writeMachine && (vendor || model || description)) {
    writeComment(localize("--- Machine ---"));
    if (vendor) {
      writeComment("  " + localize("vendor") + " - " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + " - " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + " - " + description);
    }
  }

  // dump tool information
  var toolData = {};
  var toolFormat = createFormat({ decimals: 0, width: properties.numberOfToolDigits, zeropad: true });
  if (properties.writeTools) {
    writeln("");
    writeComment("--- TOOL LIST ---");
    var zRanges = {};
    var numberOfSections = getNumberOfSections();
    for (var i = 0; i < numberOfSections; ++i) {
      var section = getSection(i);
      var tool = section.getTool();
      var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
      var toolID = "T" + toolFormat.format(tool.number) + toolFormat.format(compensationOffset) + conditional(tool.comment, "." + tool.comment);
      if (is3D()) {
        var zRange = section.getGlobalZRange();
        if (zRanges[toolID]) {
          zRanges[toolID].expandToRange(zRange);
        } else {
          zRanges[toolID] = zRange;
        }
      }

      var comment;
      if (tool.isTurningTool()) {
        var dia = section.hasParameter("operation:tool_diameter") ?
          section.getParameter("operation:tool_diameter") : 0;
        var rad = section.hasParameter("operation:tool_cornerRadius") ?
          section.getParameter("operation:tool_cornerRadius") : 0;
        var hgt = section.hasParameter("operation:tool_thickness") ?
          section.getParameter("operation:tool_thickness") : 0;

        if (unit == IN) {   // TAG: Tool parameters are always in MM?
          dia /= 25.4;
          rad /= 25.4;
          hgt /= 25.4;
        }

        comment = "DIA=" + spatialFormat.format(dia) + " " +
          localize("RAD=") + spatialFormat.format(rad) + " " +
          localize("HGT=") + spatialFormat.format(hgt) + " - " + getToolTypeName(tool.type);

      } else {
        var comment = "D=" + spatialFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + spatialFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        comment += " - " + getToolTypeName(tool.type);
      }
      toolData[toolID] = comment;
    }

    //var tools = getToolTable();
    //writeComment("Number of tools in tooltable: " + tools.getNumberOfTools());
    //if (tools.getNumberOfTools() > 0) {
    //for (var i = 0; i < tools.getNumberOfTools(); ++i) {
    for (var i in toolData) {
      //var tool = tools.getTool(i);
      /*         if (tool.isTurningTool()) {
                //var compensationOffset = tool.compensationOffset;
                //var comment = "T" + toolFormat.format(tool.number) + toolFormat.format(compensationOffset) + conditional(tool.comment, "." + tool.comment) + " " +
                var comment = i +  
            "DIA=" + spatialFormat.format(toolData[i].dia) + " " +
                  localize("RAD=") + spatialFormat.format(toolData[i].rad) + " " +
                  localize("HGT=") + spatialFormat.format(toolData[i].hgt);
               } else {
                var compensationOffset = tool.lengthOffset;
                var comment = "T" + toolFormat.format(tool.number) + toolFormat.format(compensationOffset) + conditional(tool.comment, "." + tool.comment) + " " +
                  "D=" + spatialFormat.format(tool.diameter) + " " +
                  localize("CR") + "=" + spatialFormat.format(tool.cornerRadius);
                if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
                  comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
                }
                if (zRanges[tool.number]) {
                  comment += " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum());
                }
              } */
      //comment += " - " + getToolTypeName(tool.type);
      comment = i + " - " + toolData[i];
      if (zRanges[i]) {
        comment += " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[i].getMinimum());
      }

      writeComment(comment);
    }
    //}
  }

  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (spatialFormat.areDifferent(tooli.diameter, toolj.diameter) ||
            spatialFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
            abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
            (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }
  var usesPrimarySpindle = false;
  var usesSecondarySpindle = false;
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (section.getType() != TYPE_TURNING) {
      continue;
    }
    switch (section.spindle) {
      case SPINDLE_PRIMARY:
        usesPrimarySpindle = true;
        break;
      case SPINDLE_SECONDARY:
        usesSecondarySpindle = true;
        break;
    }
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  writeln("");
  writeComment("--- PARAMETERS ---");
  writeBlock("#" + g53HomePositionXParameter + "=" + spatialFormat.format(properties.g53HomePositionX) + "(PARAMETER FOR X HOME POSITION)"); // retract
  writeBlock("#" + g53HomePositionZParameter + "=" + spatialFormat.format(properties.g53HomePositionZ) + "(PARAMETER FOR Z HOME POSITION)"); // retract
  if (gotSecondarySpindle) {
    writeBlock("#" + g53HomePositionSubZParameter + "=" + spatialFormat.format(properties.g53HomePositionSubZ) + "(PARAMETER FOR SUB Z HOME POSITION)"); // retract
  }
  if (gotYAxis) {
    writeBlock("#" + g53HomePositionYParameter + "=" + spatialFormat.format(properties.g53HomePositionY) + "(PARAMETER FOR Y HOME POSITION)"); // retract
  }
  writeln("");

  writeBlock(gMotionModal.format(0), gAbsIncModal.format(90), getCode("FEED_MODE_UNIT_MIN"), gFormat.format(54), getCode("CONSTANT_SURFACE_SPEED_OFF"));
  writeBlock(gFormat.format(40), /*gFormat.format(49),*/ gFormat.format(80), gFormat.format(67), writeDebugInfo("Cancel makro"), gFormat.format(69), writeDebugInfo("Cancel mirror mode for second revolver"), gPlaneModal.format(18));
  switch (unit) {
    case IN:
      writeBlock(gUnitModal.format(20), writeDebugInfo("Unit: Inch"));
      break;
    case MM:
      writeBlock(gUnitModal.format(21), writeDebugInfo("Unit: mm"));
      break;
  }

  if (true /*usesPrimarySpindle*/) {
    writeBlock(gFormat.format(92), sOutput.format(properties.maximumSpindleSpeed), "R1", writeDebugInfo("Spindle 1 speed limit")); // spindle 1 is the default
    sOutput.reset();
  }

  if (gotSecondarySpindle) {
    if (true /*usesSecondarySpindle*/) {
      writeBlock(gFormat.format(92), sOutput.format(properties.maximumSpindleSpeed), "R2", writeDebugInfo("Spindle 2 speed limit"));
      sOutput.reset();
    }
  }

  onCommand(COMMAND_START_CHIP_TRANSPORT);
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return "F#" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  var feedPerRev = currentSection.feedMode == FEED_PER_REVOLUTION;

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var finishFeedrateRel;
      if (hasParameter("operation:finishFeedrateRel")) {
        finishFeedrateRel = getParameter("operation:finishFeedrateRel");
      } else if (hasParameter("operation:finishFeedratePerRevolution")) {
        finishFeedrateRel = getParameter("operation:finishFeedratePerRevolution");
      }
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? finishFeedrateRel : getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), feedPerRev ? getParameter("operation:noEngagementFeedrateRel") : getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
    hasParameter("operation:tool_feedEntry") &&
    hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(
        id,
        localize("Direct"),
        Math.max(
          feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"),
          feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"),
          feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit")
        )
      );
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), feedPerRev ? getParameter("operation:reducedFeedrateRel") : getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), feedPerRev ? getParameter("operation:tool_feedRampRel") : getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), feedPerRev ? getParameter("operation:tool_feedPlungeRel") : getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if (movements & (1 << MOVEMENT_HIGH_FEED)) {
      var feedContext = new FeedContext(id, localize("High Feed"), this.highFeedrate);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("#" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentSmoothing = false;

function setSmoothing(mode) {
  if (mode == currentSmoothing) {
    return;
  }
  currentSmoothing = mode;
  writeBlock(gFormat.format(5), mode ? "P2" : "P0");
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  // milling only

  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }
  forceWorkPlane();

  if (!((currentWorkPlaneABC == undefined) ||
    abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
    abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
    abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  if (useMultiAxisFeatures) {
    var initialToolAxisBC = machineConfiguration.getABC(currentSection.workPlane);
    if (abc.isNonZero()) {
      writeBlock(gFormat.format(68.2), "X" + spatialFormat.format(0), "Y" + spatialFormat.format(0), "Z" + spatialFormat.format(0), "I" + abcFormat.format(abc.x), "J" + abcFormat.format(abc.y), "K" + abcFormat.format(abc.z)); // set frame
      writeBlock(gFormat.format(53.1) + "(" + "B" + abcFormat.format(initialToolAxisBC.y) + " C" + abcFormat.format(initialToolAxisBC.z) + ")"); // turn machine
    } else {
      writeBlock(gFormat.format(69), writeDebugInfo("Cancel mirror mode for second revolver")); // cancel frame
      writeBlock(gFormat.format(68.2), "X" + spatialFormat.format(0), "Y" + spatialFormat.format(0), "Z" + spatialFormat.format(0), "I" + abcFormat.format(0), "J" + abcFormat.format(0), "K" + abcFormat.format(0)); // cancel frame
      writeBlock(gFormat.format(53.1)); // turn machine
    }
  } else {
    writeBlock(
      gMotionModal.format(0),
      conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
      conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
      conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
    );
  }

  onCommand(COMMAND_LOCK_MULTI_AXIS);

  currentWorkPlaneABC = abc;
}

function getBestABC(section, workPlane, which) {
  var W = workPlane;
  var abc = machineConfiguration.getABC(W);
  if ((which == undefined) || useMultiAxisFeatures) { // turning, XZC, Polar modes
    // we cannot search for bestABC if useMultiAxisFeatures is enabled since it requires Euler angles in setWorkPlane
    return abc;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    var axis = machineConfiguration.getAxisU(); // C-axis is the U-axis
  } else {
    var axis = machineConfiguration.getAxisV(); // C-axis is the V-axis
  }
  if (axis.isEnabled() && axis.isTable()) {
    var ix = axis.getCoordinate();
    var rotAxis = axis.getAxis();
    if (isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ||
      isSameDirection(machineConfiguration.getDirection(abc), Vector.product(rotAxis, -1))) {
      var direction = isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ? 1 : -1;
      var box = section.getGlobalBoundingBox();
      switch (which) {
        case 1:
          x = box.upper.x - box.lower.x;
          y = box.upper.y - box.lower.y;
          break;
        case 2:
          x = box.lower.x;
          y = box.lower.y;
          break;
        case 3:
          x = box.upper.x;
          y = box.lower.y;
          break;
        case 4:
          x = box.upper.x;
          y = box.upper.y;
          break;
        case 5:
          x = box.lower.x;
          y = box.upper.y;
          break;
        default:
          var R = machineConfiguration.getRemainingOrientation(abc, W);
          x = R.right.x;
          y = R.right.y;
          break;
      }
      abc.setCoordinate(ix, getCClosest(x, y, cOutput.getCurrent()));
    }
  }
  // writeComment("Which = " + which + "  Angle = " + abc.z)
  return abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(section, workPlane) {
  var W = workPlane; // map to global frame

  // var abc = machineConfiguration.getABC(W);
  var abc = getBestABC(section, workPlane, bestABCIndex);
  if (closestABC) {
    if (currentMachineABC) {
      abc = machineConfiguration.remapToABC(abc, currentMachineABC);
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  } else {
    abc = machineConfiguration.getPreferredABC(abc);
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  if (!machineState.isTurningOperation) {
    var tcp = false;
    if (tcp) {
      setRotation(W); // TCP mode
    } else {
      var O = machineConfiguration.getOrientation(abc);
      var R = machineConfiguration.getRemainingOrientation(abc, W);
      setRotation(R);
    }
  }
  return abc;
}

function getBAxisOrientationTurning(section) {
  var toolAngle = hasParameter("operation:tool_angle") ? getParameter("operation:tool_angle") : 0;
  var toolOrientation = section.toolOrientation;
  if (toolAngle && (toolOrientation != 0)) {
    error(localize("You cannot use tool angle and tool orientation together in operation " + "\"" + (getParameter("operation-comment")) + "\""));
  }

  var angle = toRad(toolAngle) + toolOrientation;

  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 1, 0)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(1) >= 0) ? 1 : -1; // B-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(1) >= 0) ? 1 : -1; // B-axis is the V-axis
  }
  var mappedAngle = (currentSection.spindle == SPINDLE_PRIMARY ? (Math.PI / 2 - angle) : (Math.PI / 2 + angle));
  var mappedWorkplane = new Matrix(new Vector(0, direction, 0), mappedAngle);
  var abc = getWorkPlaneMachineABC(section, mappedWorkplane);

  return abc;
}

var bAxisOrientationTurning = new Vector(0, 0, 0);

function onSection() {
  writeln("");
  if (hasParameter("operation-comment")) {
    var comment = "-- Section - " + getParameter("operation-comment");

    if (comment) {
      writeComment(comment);
    }
  }

  writeln("A");

  /** detect machine configuration */
  machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainSpindle : machineConfigurationSubSpindle;
  if (!gotBAxis) {
    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL && !currentSection.isMultiAxis()) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(1, 0, 0));
    }
  } else {
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, -1));
    }
  }

  setMachineConfiguration(machineConfiguration);
  currentSection.optimizeMachineAnglesByMachine(machineConfiguration, 0); // map tip mode

  machineState.tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
      (getParameter("operation:cycleType") == "right-tapping") ||
      (getParameter("operation:cycleType") == "left-tapping") ||
      (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  bestABCIndex = undefined;

  machineState.isTurningOperation = (currentSection.getType() == TYPE_TURNING);
  if (machineState.isTurningOperation && gotBAxis) {
    bAxisOrientationTurning = getBAxisOrientationTurning(currentSection);
  }
  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.comment != getPreviousSection().getTool().comment) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  retracted = false; // specifies that the tool has been retracted to the safe plane
  var newSpindle = isFirstSection() ||
    (getPreviousSection().spindle != currentSection.spindle);
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (machineState.isTurningOperation &&
      abcFormat.areDifferent(bAxisOrientationTurning.x, machineState.currentBAxisOrientationTurning.x) ||
      abcFormat.areDifferent(bAxisOrientationTurning.y, machineState.currentBAxisOrientationTurning.y) ||
      abcFormat.areDifferent(bAxisOrientationTurning.z, machineState.currentBAxisOrientationTurning.z)) ||
    (!getPreviousSection().isMultiAxis() && currentSection.isMultiAxis());

  if (insertToolCall || newSpindle || newWorkOffset || newWorkPlane) {
    // retract to safe plane
    writeRetract(X);
    writeRetract(Z);
    writeRetract(Y);
  }

  if (newWorkPlane || insertToolCall) {
    writeBlock(gFormat.format(69), writeDebugInfo("Cancel mirror mode for second revolver")); // cancel frame
    forceWorkPlane();
  }

  writeln("B");

  updateMachiningMode(currentSection); // sets the needed machining mode to machineState (usePolarMode, useXZCMode, axialCenterDrilling)

  if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
    if (machineState.liveToolIsActive) {
      writeBlock(getCode("STOP_LIVE_TOOL"));
    }
  } else {
    if (machineState.mainSpindleIsActive) {
      writeBlock(getCode("STOP_MAIN_SPINDLE"));
    }
    if (machineState.subSpindleIsActive) {
      writeBlock(getCode("STOP_SUB_SPINDLE"));
    }
  }
  writeln("C");
  writeln("");

  if (properties.showNotes && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  writeln("D");
  if (insertToolCall) {
    writeComment("- Tool Call");
    forceWorkPlane();
    gPlaneModal.reset();

    setCoolant(COOLANT_OFF, machineState.currentTurret);
    var toolFormat = createFormat({ decimals: 0, width: properties.numberOfToolDigits, zeropad: true });
    var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
    if (properties.preloadTool) {
      if (properties.preloadTool) {
        var nextTool = getNextTool(tool.number);
        if (nextTool) {
          nextool = "T" + toolFormat.format(nextTool.number);
        } else {
          // preload first tool
          var section = getSection(0);
          var firstToolNumber = section.getTool().number;
          if (tool.number != firstToolNumber) {
            nextool = "T" + toolFormat.format(firstToolNumber);
          } else {
            nextool = "T" + toolFormat.format(0);
          }
        }
      }
      writeToolBlock("T" + toolFormat.format(tool.number) + toolFormat.format(compensationOffset) + conditional(tool.comment, "." + tool.comment), nextool/*, mFormat.format(6)*/);
    } else {
      writeToolBlock("T" + toolFormat.format(tool.number) + toolFormat.format(compensationOffset) + conditional(tool.comment, "." + tool.comment)/*, mFormat.format(6)*/);
    }

    //if (tool.comment) {
    //  writeComment(tool.comment);
    //}

    writeRetract(X);
    writeRetract(Z);
    writeRetract(Y);
    writeln("");
  }
  /** Handle multiple turrets. */
  if (gotMultiTurret) {
    var turret = tool.turret;
    if (turret == 0) {
      warning(localize("Turret has not been specified. Using Turret 1 as default."));
      turret = 1; // upper turret as default
    }
    // if (turret != machineState.currentTurret && !isFirstSection()) {
    if (turret != machineState.currentTurret) {
      // change of turret
      setCoolant(COOLANT_OFF, machineState.currentTurret);
    }
    switch (turret) {
      case 1:
        writeBlock(gFormat.format(109), "L1");
        break;
      case 2:
        writeBlock(gFormat.format(109), "L2");
        break;
      default:
        error(localize("Turret is not supported."));
        return;
    }
    machineState.currentTurret = turret;
  }
  writeln("E");
  if (!currentWorkPlaneABC) {
    if (machineState.isTurningOperation) { // diameter mode
      writeBlock(gFormat.format(123.1), writeDebugInfo("Diameter Mode")); // diameter input mode
      xFormat.setScale(2); // diameter mode
      xOutput = createVariable({ prefix: "X" }, xFormat);
    } else { // radius mode
      writeBlock(gFormat.format(122.1), writeDebugInfo("Radius Mode")); // radius input mode
      xFormat.setScale(1); // radius mode
      xOutput = createVariable({ prefix: "X" }, xFormat);
    }
  }
  writeln("F");
  if (true) {
    switch (currentSection.spindle) {
      case SPINDLE_PRIMARY: // main spindle
        writeBlock(mFormat.format(302), writeDebugInfo("Primary Spindle"));
        yFormat.setScale(1);
        yOutput = createVariable({ prefix: "Y" }, yFormat);
        zFormat.setScale(1);
        zOutput = createVariable({ prefix: "Z" }, zFormat);
        if (gotSecondarySpindle) {
          writeBlock(gSpindleModal.format(111), writeDebugInfo("Cancel cross machining control")); // cOutput.setPrefix("C");
        }
        break;
      case SPINDLE_SECONDARY: // sub spindle
        writeBlock(mFormat.format(300), writeDebugInfo("Secondary Spindle"));
        if (currentSection.isMultiAxis() || machineState.isTurningOperation) {
          yFormat.setScale(-1);
          yOutput = createVariable({ prefix: "Y" }, yFormat);
          zFormat.setScale(-1);
          zOutput = createVariable({ prefix: "Z" }, zFormat);
        } else {
          yFormat.setScale(1);
          yOutput = createVariable({ prefix: "Y" }, yFormat);
          zFormat.setScale(1);
          zOutput = createVariable({ prefix: "Z" }, zFormat);
        }
        if (newSpindle) {
          writeBlock(gSpindleModal.format(110) + " C2", writeDebugInfo("Activating cross machining control to C2")); //  cOutput.setPrefix("U");
        }
        break;
    }
    if (!gotYAxis) {
      yOutput.disable();
    }
  }
  writeln("G");
  if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) { //turning
    writeBlock(conditional(machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("DISENGAGE_C_AXIS"));
    writeBlock(conditional(machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("LOCK_MILLING_SPINDLE"));
  } else { // milling
    writeBlock(conditional(!machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("ENGAGE_C_AXIS"));
    writeBlock(conditional(!machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("UNLOCK_MILLING_SPINDLE"));
  }
  writeln("H");
  if ((currentSection.feedMode == FEED_PER_REVOLUTION) || machineState.tapping || machineState.axialCenterDrilling) {
    writeBlock(getCode("FEED_MODE_UNIT_REV")); // mm/rev
  } else {
    writeBlock(getCode("FEED_MODE_UNIT_MIN")); // mm/min
  }
  writeln("I");
  // Engage tailstock
  if (gotTailStock) {
    if (machineState.axialCenterDrilling || (currentSection.spindle == SPINDLE_SECONDARY) ||
      (machineState.liveToolIsActive && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      if (currentSection.tailstock) {
        warning(localize("Tail stock is not supported for secondary spindle or Z-axis milling."));
      }
      if (machineState.tailstockIsActive) {
        writeBlock(getCode("TAILSTOCK_OFF"));
      }
    } else {
      writeBlock(currentSection.tailstock ? getCode("TAILSTOCK_ON") : getCode("TAILSTOCK_OFF"));
    }
  }

  if (insertToolCall ||
    newSpindle ||
    isFirstSection() ||
    isSpindleSpeedDifferent()) {
    if (spindleSpeed < 1 && tool.getSpindleMode() != SPINDLE_CONSTANT_SURFACE_SPEED) {
      error(localize("Spindle speed out of range."));
      return;
    }
    if (machineState.isTurningOperation) {
      if (spindleSpeed > 99999) {
        warning(localize("Spindle speed exceeds maximum value."));
      }
    } else {
      if (spindleSpeed > 10000) {
        warning(localize("Spindle speed exceeds maximum value."));
      }
    }
    startSpindle(true, getFramePosition(currentSection.getInitialPosition()));
  }
  writeln("J");
  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = currentSection.workOffset;
  if (workOffset == 0) {
    warningOnce(localize("Work offset has not been specified. Using G54 as WCS."), WARNING_WORK_OFFSET);
    workOffset = 1;
  }
  if (workOffset > 0) {
    if (workOffset > 6) {
      var code = workOffset - 6;
      if (code > 48) {
        error(localize("Work offset out of range."));
        return;
      }
      if (workOffset != currentWorkOffset) {
        writeBlock(gFormat.format(54.1), "P" + code);
        currentWorkOffset = workOffset;
      }
    } else {
      if (workOffset != currentWorkOffset) {
        writeBlock(gFormat.format(53 + workOffset)); // G54->G59
        currentWorkOffset = workOffset;
      }
    }
  }
  writeln("K");
  /*
    if (gotYAxis) {
      writeBlock(gMotionModal.format(0), "Y" + yFormat.format(0));
      yOutput.reset();
    }
  */

  if (properties.useParametricFeed &&
    hasParameter("operation-strategy") &&
    (getParameter("operation-strategy") != "drill") && // legacy
    !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
      activeMovements &&
      (getCurrentSectionId() > 0) &&
      (getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0)) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }
  writeln("L");
  gMotionModal.reset();

  var abc;
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) { // turning toolpath
      if (gotBAxis) {
        cancelTransformation();
        abc = bAxisOrientationTurning;
        writeBlock(getCode("UNCLAMP_B_AXIS"));
        writeBlock(gMotionModal.format(0), gFormat.format(53), "B" + abcFormat.format(bAxisOrientationTurning.y));
        writeBlock(getCode("CLAMP_B_AXIS"));
        machineState.currentBAxisOrientationTurning = abc;
      } else {
        setRotation(currentSection.workPlane);
      }
    } else { // milling toolpath
      writeln("L.1");
      if (currentSection.isMultiAxis()) {
        writeln("L.1.1");
        forceWorkPlane();
        cancelTransformation();
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      } else {
        writeln("L.1.2");
        if (machineState.useXZCMode) {
          writeln("L.1.2.1");
          setRotation(currentSection.workPlane); // enables calculation of the C-axis by tool XY-position
          abc = useMultiAxisFeatures ? new Vector(0, 0, 0) : new Vector(0, 0, getCWithinRange(getFramePosition(currentSection.getInitialPosition()).x, getFramePosition(currentSection.getInitialPosition()).y, cOutput.getCurrent()));
        } else {
          writeln("L.1.2.2");
          if (useMultiAxisFeatures) {
            writeln("L.1.2.2.1");
            if (currentSection.spindle == SPINDLE_PRIMARY) {
              abc = currentSection.workPlane.getEuler2(EULER_ZXZ_R);
            } else {
              var orientation = currentSection.workPlane;
              orientation = new Matrix(orientation.getRight(), orientation.getUp().getNegated(), orientation.getForward().getNegated());
              abc = orientation.getEuler2(EULER_ZXZ_R);
              abc = new Vector(-abc.x, abc.y, -abc.z); // needed for secondary spindle
            }
          } else {
            writeln("L.1.2.2.2");
            abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
          }
        }
        setWorkPlane(abc);
      }
    }
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported by the CNC machine."));
      return;
    }
    setRotation(remaining);
  }
  forceAny();
  writeln("M");
  if (abc !== undefined) {
    if (!currentSection.isMultiAxis()) {
      cOutput.format(abc.z); // make C current - we do not want to output here
    }
  }
  gMotionModal.reset();
  writeln("N");
  /*
    if (!retracted) {
      // TAG: need to retract along X or Z
      if (getCurrentPosition().z < initialPosition.z) {
        writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      }
    }
  */

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (insertToolCall || retracted) {
    gPlaneModal.reset();
    gFeedModeModal.reset();
  }
  writeln("O");
  // assumes a Head configuration uses TCP on a Fanuc controller
  var offsetCode = 43;
  if (currentSection.isMultiAxis()) {
    if (machineConfiguration.isMultiAxisConfiguration() && (currentSection.getOptimizedTCPMode() == 0)) {
      offsetCode = 43.4;
    } else if (!machineConfiguration.isMultiAxisConfiguration()) {
      offsetCode = 43.5;
    }
  }
  writeln("P");
  if (currentSection.isMultiAxis()) {
    // turn
    var abc;
    forceABC();
    if (currentSection.isOptimizedForMachine()) {
      abc = currentSection.getInitialToolAxisABC();
      writeBlock(
        gMotionModal.format(0), gAbsIncModal.format(90),
        aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z)
      );
    } else {
      var d = currentSection.getGlobalInitialToolAxis();
      writeBlock(
        gMotionModal.format(0), gAbsIncModal.format(90),
        "I" + spatialFormat.format(d.x), "J" + spatialFormat.format(d.y), "K" + spatialFormat.format(d.z)
      );
    }

    writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), xOutput.format(initialPosition.x), zOutput.format(initialPosition.z), yOutput.format(initialPosition.y));
  } else {
    gPlaneModal.reset();
    gMotionModal.reset();
    if (machineState.useXZCMode) {
      writeBlock(gPlaneModal.format(17));
      cOutput.reset();
      writeBlock(
        gMotionModal.format(0),
        xOutput.format(getModulus(initialPosition.x, initialPosition.y)),
        conditional(gotYAxis, yOutput.format(0)),
        cOutput.format(getCWithinRange(initialPosition.x, initialPosition.y, cOutput.getCurrent()))
      );
      writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), zOutput.format(initialPosition.z));
    } else {
      writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z));
    }
  }
  writeln("Q");
  // enable SFM spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false);
  }
  writeln("R");
  // set coolant after we have positioned at Z
  setCoolant(tool.coolant, machineState.currentTurret);
  writeln("S");
  if (machineState.usePolarMode) {
    setPolarMode(true); // enable polar interpolation mode
  }

  if (writeDebug) { // DEBUG
    for (var key in machineState) {
      writeComment(key + " = " + machineState[key]);
    }
    // writeln((getMachineConfigurationAsText(machineConfiguration)));
  }
  if (properties.useSmoothing) {
    if ((currentSection.getType() == TYPE_MILLING) &&
      hasParameter("operation-strategy") && (getParameter("operation-strategy") != "drill")) {
      setSmoothing(true);
    } else {
      setSmoothing(false);
    }
  }
  retracted = false;
}

/** Returns true if the toolpath fits within the machine XY limits for the given C orientation. */
function doesToolpathFitInXYRange(abc) {
  var c = 0;
  if (abc) {
    c = abc.z;
  }

  var dx = new Vector(Math.cos(c), Math.sin(c), 0);
  var dy = new Vector(Math.cos(c + Math.PI / 2), Math.sin(c + Math.PI / 2), 0);

  if (currentSection.getGlobalRange) {
    var xRange = currentSection.getGlobalRange(dx);
    var yRange = currentSection.getGlobalRange(dy);

    if (writeDebug) { // DEBUG
      writeComment(
        "toolpath X minimum= " + xFormat.format(xRange[0]) + ", " + "Limit= " + xFormat.format(xAxisMinimum) + ", " +
        "within range= " + (xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum))
      );
      writeComment(
        "toolpath Y minimum= " + spatialFormat.getResultingValue(yRange[0]) + ", " + "Limit= " + yAxisMinimum + ", " +
        "within range= " + (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum)
      );
      writeComment(
        "toolpath Y maximum= " + (spatialFormat.getResultingValue(yRange[1]) + ", " + "Limit= " + yAxisMaximum) + ", " +
        "within range= " + (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)
      );
      writeln("");
    }

    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if ((spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum) &&
        (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    } else { // G17 plane
      if ((xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum)) &&
        (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum) &&
        (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    }
  } else {
    if (revision < 40000) {
      warning(localize("Please update to the latest release to allow XY linear interpolation instead of polar interpolation."));
    }
    return false; // for older versions without the getGlobalRange() function
  }
}

var MACHINING_DIRECTION_AXIAL = 0;
var MACHINING_DIRECTION_RADIAL = 1;
var MACHINING_DIRECTION_INDEXING = 2;

function getMachiningDirection(section) {
  var forward = section.isMultiAxis() ? section.getGlobalInitialToolAxis() : section.workPlane.forward;
  if (isSameDirection(forward, new Vector(0, 0, 1))) {
    machineState.machiningDirection = MACHINING_DIRECTION_AXIAL;
    return MACHINING_DIRECTION_AXIAL;
  } else if (Vector.dot(forward, new Vector(0, 0, 1)) < 1e-7) {
    machineState.machiningDirection = MACHINING_DIRECTION_RADIAL;
    return MACHINING_DIRECTION_RADIAL;
  } else {
    machineState.machiningDirection = MACHINING_DIRECTION_INDEXING;
    return MACHINING_DIRECTION_INDEXING;
  }
}

function updateMachiningMode(section) {
  machineState.axialCenterDrilling = false; // reset
  machineState.usePolarMode = false; // reset
  machineState.useXZCMode = false; // reset

  if ((section.getType() == TYPE_MILLING) && !section.isMultiAxis()) {
    if (getMachiningDirection(section) == MACHINING_DIRECTION_AXIAL) {
      if (section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "drill")) {
        // drilling axial
        if ((section.getNumberOfCyclePoints() == 1) &&
          !xFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).x) &&
          !yFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).y) &&
          (spatialFormat.format(section.getFinalPosition().x) == 0) &&
          !doesCannedCycleIncludeYAxisMotion()) { // catch drill issue for old versions
          // single hole on XY center
          if (section.getTool().isLiveTool && section.getTool().isLiveTool()) {
            // use live tool
          } else {
            // use main spindle for axialCenterDrilling
            machineState.axialCenterDrilling = true;
          }
        } else {
          // several holes not on XY center, use live tool in XZCMode
          machineState.useXZCMode = true;
        }
      } else { // milling
        if (forcePolarMode) {
          machineState.usePolarMode = true;
        } else if (forceXZCMode) {
          machineState.useXZCMode = true;
        } else {
          fitFlag = false;
          bestABCIndex = undefined;
          for (var i = 0; i < 6; ++i) {
            fitFlag = doesToolpathFitInXYRange(getBestABC(section, section.workPlane, i));
            if (fitFlag) {
              bestABCIndex = i;
              break;
            }
          }
          if (!fitFlag) { // does not fit, set polar/XZC mode
            if (gotPolarInterpolation) {
              machineState.usePolarMode = true;
            } else {
              machineState.useXZCMode = true;
            }
          }
        }
      }
    } else if (getMachiningDirection(section) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if (!gotYAxis) {
        if (!section.isMultiAxis() && !doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) && doesCannedCycleIncludeYAxisMotion()) {
          error(subst(localize("Y-axis motion is not possible without a Y-axis for operation \"%1\"."), getOperationComment()));
          return;
        }
      } else {
        if (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) || forceXZCMode) {
          error(subst(localize("Toolpath exceeds the maximum ranges for operation \"%1\"."), getOperationComment()));
          return;
        }
      }
      // C-coordinates come from setWorkPlane or is within a multi axis operation, we cannot use the C-axis for non wrapped toolpathes (only multiaxis works, all others have to be into XY range)
    } else {
      // useXZCMode & usePolarMode is only supported for axial machining, keep false
    }
  } else {
    // turning or multi axis, keep false
  }

  if (machineState.axialCenterDrilling) {
    cOutput.disable();
  } else {
    cOutput.enable();
  }

  var checksum = 0;
  checksum += machineState.usePolarMode ? 1 : 0;
  checksum += machineState.useXZCMode ? 1 : 0;
  checksum += machineState.axialCenterDrilling ? 1 : 0;
  validate(checksum <= 1, localize("Internal post processor error."));
}

function doesCannedCycleIncludeYAxisMotion() {
  // these cycles have Y axis motions which are not detected by getGlobalRange()
  var hasYMotion = false;
  if (hasParameter("operation:strategy") && (getParameter("operation:strategy") == "drill")) {
    switch (getParameter("operation:cycleType")) {
      case "thread-milling":
      case "bore-milling":
      case "circular-pocket-milling":
        hasYMotion = true; // toolpath includes Y-axis motion
        break;
      case "back-boring":
      case "fine-boring":
        var shift = getParameter("operation:boringShift");
        if (shift != spatialFormat.format(0)) {
          hasYMotion = true; // toolpath includes Y-axis motion
        }
        break;
      default:
        hasYMotion = false; // all other cycles do not have Y-axis motion
    }
  } else {
    hasYMotion = true;
  }
  return hasYMotion;
}

function getOperationComment() {
  var operationComment = hasParameter("operation-comment") && getParameter("operation-comment");
  return operationComment;
}

function setPolarMode(activate) {
  if (activate) {
    cOutput.reset();
    writeBlock(gMotionModal.format(0), cOutput.format(0)); // set C-axis to 0
    gPlaneModal.reset();
    writeBlock(gPlaneModal.format(17) + "XC");
    writeBlock(getCode("POLAR_INTERPOLATION_ON")); // command for polar interpolation
    xFormat.setScale(1); // radius mode
    xOutput = createVariable({ prefix: "X" }, xFormat);
    yOutput.enable();
    yOutput.setPrefix("C");
  } else {
    writeBlock(getCode("POLAR_INTERPOLATION_OFF"));
    xFormat.setScale(2); // diameter mode
    xOutput = createVariable({ prefix: "X" }, xFormat);
    yOutput.setPrefix("Y");
    if (!gotYAxis) {
      yOutput.disable();
    }
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  milliseconds = clamp(1, seconds * 1000, 99999999);
  writeBlock(gFeedModeModal.format(94), gFormat.format(4), "P" + milliFormat.format(milliseconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

var resetFeed = false;

function getHighfeedrate(radius) {
  if (currentSection.feedMode == FEED_PER_REVOLUTION) {
    if (toDeg(radius) <= 0) {
      radius = toPreciseUnit(0.1, MM);
    }
    var rpm = spindleSpeed; // rev/min
    if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      var O = 2 * Math.PI * radius; // in/rev
      rpm = tool.surfaceSpeed / O; // in/min div in/rev => rev/min
    }
    return highFeedrate / rpm; // in/min div rev/min => in/rev
  }
  return highFeedrate;
}

function onRapid(_x, _y, _z) {
  if (machineState.useXZCMode) {
    var start = getCurrentPosition();
    var dxy = getModulus(_x - start.x, _y - start.y);
    if (true || (dxy < getTolerance())) {
      var x = xOutput.format(getModulus(_x, _y));
      var c = cOutput.format(getCWithinRange(_x, _y, cOutput.getCurrent()));
      var z = zOutput.format(_z);
      if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation mode cannot be changed at rapid traversal."));
        return;
      }
      if (forceRewind) {
        rewindTable(start, _z, cOutput.getCurrent(), highFeedrate, false);
      }
      writeBlock(gMotionModal.format(0), x, c, z);
      forceFeed();
      return;
    }

    onExpandedLinear(_x, _y, _z, highFeedrate);
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    writeBlock(gMotionModal.format(0), x, y, z);
    forceFeed();
    resetFeed = false;
  }
}

/** Calculate the distance of a point to a line segment. */
function pointLineDistance(startPt, endPt, testPt) {
  var delta = Vector.diff(endPt, startPt);
  distance = Math.abs(delta.y * testPt.x - delta.x * testPt.y + endPt.x * startPt.y - endPt.y * startPt.x) /
    Math.sqrt(delta.y * delta.y + delta.x * delta.x); // distance from line to point
  if (distance < 1e-4) { // make sure point is in line segment
    var moveLength = Vector.diff(endPt, startPt).length;
    var startLength = Vector.diff(startPt, testPt).length;
    var endLength = Vector.diff(endPt, testPt).length;
    if ((startLength > moveLength) || (endLength > moveLength)) {
      distance = Math.min(startLength, endLength);
    }
  }
  return distance;
}

/** Refine segment for XC mapping. */
function refineSegmentXC(startX, startC, endX, endC, maximumDistance) {
  var rotary = machineConfiguration.getAxisU(); // C-axis
  var startPt = rotary.getAxisRotation(startC).multiply(new Vector(startX, 0, 0));
  var endPt = rotary.getAxisRotation(endC).multiply(new Vector(endX, 0, 0));

  var testX = startX + (endX - startX) / 2; // interpolate as the machine
  var testC = startC + (endC - startC) / 2;
  var testPt = rotary.getAxisRotation(testC).multiply(new Vector(testX, 0, 0));

  var delta = Vector.diff(endPt, startPt);
  var distf = pointLineDistance(startPt, endPt, testPt);

  if (distf > maximumDistance) {
    return false; // out of tolerance
  } else {
    return true;
  }
}

function rewindTable(startXYZ, currentZ, rewindC, feed, retract) {
  if (!cFormat.areDifferent(rewindC, cOutput.getCurrent())) {
    error(localize("Rewind position not found."));
    return;
  }
  writeComment("Rewind of C-axis, make sure retracting is possible.");
  onCommand(COMMAND_STOP);
  if (retract) {
    writeBlock(gMotionModal.format(1), zOutput.format(currentSection.getInitialPosition().z), getFeed(feed));
  }
  writeBlock(getCode("DISENGAGE_C_AXIS"));
  writeBlock(getCode("ENGAGE_C_AXIS"));
  gMotionModal.reset();
  xOutput.reset();
  startSpindle(false);
  if (retract) {
    var x = getModulus(startXYZ.x, startXYZ.y);
    if (properties.rapidRewinds) {
      writeBlock(gMotionModal.format(1), xOutput.format(x), getFeed(highFeedrate));
      writeBlock(gMotionModal.format(0), cOutput.format(rewindC));
    } else {
      writeBlock(gMotionModal.format(1), xOutput.format(x), cOutput.format(rewindC), getFeed(highFeedrate));
    }
    writeBlock(gMotionModal.format(1), zOutput.format(startXYZ.z), getFeed(feed));
  }
  setCoolant(tool.coolant, machineState.currentTurret);
  forceRewind = false;
  writeComment("End of rewind");
}

function onLinear(_x, _y, _z, feed) {
  if (properties.useSmoothing) {
    setSmoothing(true);
  }

  if (machineState.useXZCMode) {
    if (pendingRadiusCompensation >= 0) {
      error(subst(localize("Radius compensation is not supported by using XZC mode for operation \"%1\"."), getOperationComment()));
      return;
    }
    if (maximumCircularSweep > toRad(179)) {
      error(localize("Maximum circular sweep must be below 179 degrees."));
      return;
    }

    var localTolerance = getTolerance() / 4;

    var startXYZ = getCurrentPosition();
    var startX = getModulus(startXYZ.x, startXYZ.y);
    var startZ = startXYZ.z;
    var startC = cOutput.getCurrent();

    var endXYZ = new Vector(_x, _y, _z);
    var endX = getModulus(endXYZ.x, endXYZ.y);
    var endZ = endXYZ.z;
    var endC = getCWithinRange(endXYZ.x, endXYZ.y, startC);

    var currentXYZ = endXYZ; var currentX = endX; var currentZ = endZ; var currentC = endC;
    var centerXYZ = machineConfiguration.getAxisU().getOffset();

    var refined = true;
    var crossingRotary = false;
    // forceOptimized = false; // tool tip is provided to DPM calculations
    while (refined) { // stop if we dont refine
      // check if we cross center of rotary axis
      var _start = new Vector(startXYZ.x, startXYZ.y, 0);
      var _current = new Vector(currentXYZ.x, currentXYZ.y, 0);
      var _center = new Vector(centerXYZ.x, centerXYZ.y, 0);
      if ((xFormat.getResultingValue(pointLineDistance(_start, _current, _center)) == 0) &&
        (xFormat.getResultingValue(Vector.diff(_start, _center).length) != 0) &&
        (xFormat.getResultingValue(Vector.diff(_current, _center).length) != 0)) {
        var ratio = Vector.diff(_center, _start).length / Vector.diff(_current, _start).length;
        currentXYZ = centerXYZ;
        currentXYZ.z = startZ + (endZ - startZ) * ratio;
        currentX = getModulus(currentXYZ.x, currentXYZ.y);
        currentZ = currentXYZ.z;
        currentC = startC;
        crossingRotary = true;
      } else { // check if move is out of tolerance
        refined = false;
        while (!refineSegmentXC(startX, startC, currentX, currentC, localTolerance)) { // move is out of tolerance
          refined = true;
          currentXYZ = Vector.lerp(startXYZ, currentXYZ, 0.75);
          currentX = getModulus(currentXYZ.x, currentXYZ.y);
          currentZ = currentXYZ.z;
          currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
          if (Vector.diff(startXYZ, currentXYZ).length < 1e-5) { // back to start point, output error
            if (forceRewind) {
              break;
            } else {
              warning(localize("Linear move cannot be mapped to rotary XZC motion."));
              break;
            }
          }
        }
      }

      currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
      if (forceRewind) {
        var rewindC = getCClosest(startXYZ.x, startXYZ.y, currentC);
        xOutput.reset(); // force X for repositioning
        rewindTable(startXYZ, currentZ, rewindC, feed, true);
      }
      var x = xOutput.format(currentX);
      var c = cOutput.format(currentC);
      var z = zOutput.format(currentZ);
      if (x || c || z) {
        writeBlock(gMotionModal.format(1), x, c, z, getFeed(feed));
      }
      setCurrentPosition(currentXYZ);
      if (crossingRotary) {
        writeBlock(gMotionModal.format(1), cOutput.format(endC), getFeed(feed)); // rotate at X0 with endC
        forceFeed();
      }
      startX = currentX; startZ = currentZ; startC = crossingRotary ? endC : currentC; startXYZ = currentXYZ; // loop start point
      currentX = endX; currentZ = endZ; currentC = endC; currentXYZ = endXYZ; // loop end point
      crossingRotary = false;
    }
    // forceOptimized = undefined;
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    resetFeed = true;
    var threadPitch = getParameter("operation:threadPitch");
    var threadsPerInch = 1.0 / threadPitch; // per mm for metric
    writeBlock(gMotionModal.format(32), xOutput.format(_x), yOutput.format(_y), zOutput.format(_z), pitchOutput.format(1 / threadsPerInch));
    return;
  }
  if (resetFeed) {
    resetFeed = false;
    forceFeed();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = ((currentSection.feedMode != FEED_PER_REVOLUTION) && machineState.feedPerRevolution) ? feedOutput.format(feed / spindleSpeed) : getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (machineState.isTurningOperation) {
        writeBlock(gPlaneModal.format(18));
      } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
        writeBlock(gPlaneModal.format(17));
      } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
        writeBlock(gPlaneModal.format(17));
      } else {
        // error(localize("Tool orientation is not supported for radius compensation."));
        // return;
      }
      switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(41), x, y, z, f);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(42), x, y, z, f);
          break;
        default:
          writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }

  if (!currentSection.isOptimizedForMachine()) {
    forceXYZ();
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);

  if (currentSection.isOptimizedForMachine()) {
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
  } else {
    var i = spatialFormat.format(_a);
    var j = spatialFormat.format(_b);
    var k = spatialFormat.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, "I" + i, "J" + j, "K" + k);
  }
  forceFeed();
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  if (!currentSection.isOptimizedForMachine()) {
    forceXYZ();
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);

  if (currentSection.isOptimizedForMachine()) {
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    var f = getFeed(feed);
    if (x || y || z || a || b || c) {
      writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
    } else if (f) {
      if (getNextRecord().isMotion()) { // try not to output feed without motion
        forceFeed(); // force feed on next line
      } else {
        writeBlock(gMotionModal.format(1), f);
      }
    }
  } else {
    var i = spatialFormat.format(_a);
    var j = spatialFormat.format(_b);
    var k = spatialFormat.format(_c);
    var f = getFeed(feed);
    if (x || y || z || i || j || k) {
      writeBlock(gMotionModal.format(1), x, y, z, "I" + i, "J" + j, "K" + k, f);
    } else if (f) {
      if (getNextRecord().isMotion()) { // try not to output feed without motion
        forceFeed(); // force feed on next line
      } else {
        writeBlock(gMotionModal.format(1), f);
      }
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (isHelical() && properties.useSmoothing) {
    setSmoothing(false);
  }

  if (machineState.useXZCMode) {
    switch (getCircularPlane()) {
      case PLANE_ZX:
        if (!isSpiral()) {
          var c = getCClosest(x, y, cOutput.getCurrent());
          if (!cFormat.areDifferent(c, cOutput.getCurrent())) {
            validate(getCircularSweep() < Math.PI, localize("Circular sweep exceeds limit."));
            var start = getCurrentPosition();
            writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
            return;
          }
        }
        break;
      case PLANE_XY:
        var d2 = center.x * center.x + center.y * center.y;
        if (d2 < 1e-6) { // center is on rotary axis
          var c = getCWithinRange(x, y, cOutput.getCurrent(), !clockwise);
          if (!forceRewind) {
            writeBlock(gMotionModal.format(1), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), getFeed(feed));
            return;
          }
        }
        break;
    }

    linearize(getTolerance());
    return;
  }

  if (machineState.usePolarMode) {
    linearize(getTolerance());
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();
  forceXYZ();

  if (isSpiral()) {
    var startRadius = getCircularStartRadius();
    var endRadius = getCircularRadius();
    var dr = Math.abs(endRadius - startRadius);
    if (dr > maximumCircularRadiiDifference) { // maximum limit
      if (isHelical()) { // not supported
        linearize(tolerance);
        return;
      }
      switch (getCircularPlane()) {
        case PLANE_XY:
          writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2.1 : 3.1), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
          break;
        case PLANE_ZX:
          writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2.1 : 3.1), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
          break;
        case PLANE_YZ:
          writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2.1 : 3.1), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
          break;
        default:
          linearize(tolerance);
      }
      return;
    }
  }

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
        break;
      case PLANE_ZX:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
        break;
      case PLANE_YZ:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
        break;
      default:
        linearize(tolerance);
    }
  } else if (!properties.useRadius) {
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) { // avoid G112 issue
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        if (!xFormat.isSignificant(start.x) && machineState.usePolarMode) {
          writeBlock(gMotionModal.format(1), xOutput.format((unit == IN) ? 0.0001 : 0.001), getFeed(feed)); // move X to non zero to avoid G112 issues
        }
        writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
        break;
      case PLANE_ZX:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
        break;
      case PLANE_YZ:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
        break;
      default:
        linearize(tolerance);
    }
  } else { // use radius mode
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) {
      linearize(tolerance);
      return;
    }
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        if ((spatialFormat.format(start.x) == 0) && machineState.usePolarMode) {
          writeBlock(gMotionModal.format(1), xOutput.format((unit == IN) ? 0.0001 : 0.001), getFeed(feed)); // move X to non zero to avoid G112 issues
        }
        writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      case PLANE_ZX:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      case PLANE_YZ:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      default:
        linearize(tolerance);
    }
  }
}

function onCycle() {
  if (isSubSpindleCycle && isSubSpindleCycle(cycleType)) {
    error(localize("Stock transfer is not supported."));
    return;
  }
}

function getCommonCycle(x, y, z, r) {
  forceXYZ(); // force xyz on first drill hole of any cycle
  if (machineState.useXZCMode) {
    cOutput.reset();
    return [xOutput.format(getModulus(x, y)), cOutput.format(getCWithinRange(x, y, cOutput.getCurrent())),
    zOutput.format(z),
    "R" + spatialFormat.format(r)];
  } else {
    return [xOutput.format(x), yOutput.format(y),
    zOutput.format(z),
    "R" + spatialFormat.format(r)];
  }
}

function onCyclePoint(x, y, z) {
  if (properties.useSmoothing) {
    setSmoothing(false);
  }
  if (!properties.useCycles) {
    expandCyclePoint(x, y, z);
    return;
  }

  switch (cycleType) {
    case "thread-turning":
      error("Thread turning using cycle is not supported. Please disable the --useCycle-- option into the threading operation.");
      return;
    // var i = -cycle.incrementalX; // positive if taper goes down - delta radius
    // var threadsPerInch = 1.0/cycle.pitch; // per mm for metric
    // var f = 1/threadsPerInch;
    // writeBlock(gMotionModal.format(92), xOutput.format(x - cycle.incrementalX), yOutput.format(y), zOutput.format(z), conditional(zFormat.isSignificant(i), g92IOutput.format(i)), pitchOutput.format(f));
    // forceFeed();
    // return;
  }

  if (isFirstCyclePoint() || (getParameter("operation:cycleType") == "tapping-with-chip-breaking")) {
    repositionToCycleClearance(cycle, x, y, z);

    // return to initial Z which is clearance plane and set absolute mode

    var F = (machineState.feedPerRevolution ? cycle.feedrate / spindleSpeed : cycle.feedrate);
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
      case "drilling":
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(83),
          getCommonCycle(x, y, z, cycle.retract),
          feedOutput.format(F)
        );
        break;
      case "counter-boring":
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(83),
          getCommonCycle(x, y, z, cycle.retract),
          "Q" + spatialFormat.format(cycle.incrementalDepth),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F)
        );
        break;
      case "deep-drilling":
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(83),
          getCommonCycle(x, y, z, cycle.retract),
          "Q" + spatialFormat.format(cycle.incrementalDepth),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F)
        );
        break;
      case "chip-breaking":
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(83),
          getCommonCycle(x, y, z, cycle.retract),
          "Q" + spatialFormat.format(cycle.incrementalDepth),
          "D" + spatialFormat.format(cycle.chipBreakDistance),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F)
        );
        break;
      case "tapping":
      case "right-tapping":
      case "left-tapping":
        if (!F) {
          F = tool.getTappingFeedrate();
        }
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(84.2),
          getCommonCycle(x, y, z, cycle.retract),
          pitchOutput.format(tool.threadPitch)
        );
        forceFeed();
        break;
      case "tapping-with-chip-breaking":
        if (!F) {
          F = tool.getTappingFeedrate();
        }

        var u = cycle.stock;
        var step = cycle.incrementalDepth;
        var first = true;

        while (u > cycle.bottom) {
          if (step < cycle.minimumIncrementalDepth) {
            step = cycle.minimumIncrementalDepth;
          }
          u -= step;
          step -= cycle.incrementalDepthReduction;
          gCycleModal.reset(); // required
          u = Math.max(u, cycle.bottom);
          if (first) {
            first = false;
            writeBlock(
              gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(84.2),
              getCommonCycle(x, y, u, cycle.retract),
              pitchOutput.format(tool.threadPitch)
            );
          } else {
            writeBlock(
              gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(84.2),
              getCommonCycle(x, y, u, cycle.retract),
              pitchOutput.format(tool.threadPitch)
            );
          }
        }
        forceFeed();
        break;
      case "reaming":
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(85),
          getCommonCycle(x, y, z, cycle.retract),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F)
        );
        break;
      default:
        expandCyclePoint(x, y, z);
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else if (machineState.useXZCMode) {
      var _x = xOutput.format(getModulus(x, y));
      var _c = cOutput.format(getCWithinRange(x, y, cOutput.getCurrent()));
      if (!_x /*&& !_y*/ && !_c) {
        xOutput.reset(); // at least one axis is required
        _x = xOutput.format(getModulus(x, y));
      }
      writeBlock(_x, _c);
    } else {
      var _x = xOutput.format(x);
      var _y = yOutput.format(y);
      var _z = zOutput.format(z);
      if (!_x && !_y && !_z) {
        switch (gPlaneModal.getCurrent()) {
          case 17: // XY
            xOutput.reset(); // at least one axis is required
            _x = xOutput.format(x);
            break;
          case 18: // ZX
            zOutput.reset(); // at least one axis is required
            _z = zOutput.format(z);
            break;
          case 19: // YZ
            yOutput.reset(); // at least one axis is required
            _y = yOutput.format(y);
            break;
        }
      }
      writeBlock(_x, _y, _z);
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded) {
    switch (cycleType) {
      case "thread-turning":
        forceFeed();
        xOutput.reset();
        zOutput.reset();
        g92IOutput.reset();
        break;
      default:
        writeBlock(gCycleModal.format(80));
    }
  }
}

function onPassThrough(text) {
  writeBlock(text);
}

function onParameter(name, value) {
  var invalid = false;
  switch (name) {
    case "action":
      if (String(value).toUpperCase() == "USEXZCMODE") {
        forceXZCMode = true;
        forcePolarMode = false;
      } else if (String(value).toUpperCase() == "USEPOLARMODE") {
        forcePolarMode = true;
        forceXZCMode = false;
      } else {
        invalid = true;
      }
  }
  if (invalid) {
    error(localize("Invalid action parameter: ") + value);
    return;
  }
}

var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;

function setCoolant(coolant, turret) {
  // if (turret == undefined) {
  //   error(localize("Turret is not defined for coolant command."));
  //   return undefined;
  // }
  var coolantCodes = getCoolantCodes(coolant, gotMultiTurret ? turret : 1);
  if (Array.isArray(coolantCodes)) {
    for (var c in coolantCodes) {
      writeBlock(coolantCodes[c], writeDebugInfo("Coolant"));
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant, turret) {
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (!coolantOff) { // use the default coolant off command when an 'off' value is not specified for the previous coolant mode
    coolantOff = coolants.off;
  }

  if (coolant == currentCoolantMode) {
    return undefined; // coolant is already active
  }

  var m;
  if (coolant == COOLANT_OFF) {
    m = coolantOff;
    coolantOff = coolants.off;
  }

  switch (coolant) {
    case COOLANT_FLOOD:
      if (!coolants.flood) {
        break;
      }
      m = (turret == 1) ? coolants.flood.turret1.on : coolants.flood.turret2.on;
      coolantOff = (turret == 1) ? coolants.flood.turret1.off : coolants.flood.turret2.off;
      break;
    case COOLANT_THROUGH_TOOL:
      if (!coolants.throughTool) {
        break;
      }
      m = (turret == 1) ? coolants.throughTool.turret1.on : coolants.throughTool.turret2.on;
      coolantOff = (turret == 1) ? coolants.throughTool.turret1.off : coolants.throughTool.turret2.off;
      break;
    case COOLANT_AIR:
      if (!coolants.air) {
        break;
      }
      m = (turret == 1) ? coolants.air.turret1.on : coolants.air.turret2.on;
      coolantOff = (turret == 1) ? coolants.air.turret1.off : coolants.air.turret2.off;
      break;
    case COOLANT_AIR_THROUGH_TOOL:
      if (!coolants.airThroughTool) {
        break;
      }
      m = (turret == 1) ? coolants.airThroughTool.turret1.on : coolants.airThroughTool.turret2.on;
      coolantOff = (turret == 1) ? coolants.airThroughTool.turret1.off : coolants.airThroughTool.turret2.off;
      break;
    case COOLANT_FLOOD_MIST:
      if (!coolants.floodMist) {
        break;
      }
      m = (turret == 1) ? coolants.floodMist.turret1.on : coolants.floodMist.turret2.on;
      coolantOff = (turret == 1) ? coolants.floodMist.turret1.off : coolants.floodMist.turret2.off;
      break;
    case COOLANT_MIST:
      if (!coolants.mist) {
        break;
      }
      m = (turret == 1) ? coolants.mist.turret1.on : coolants.mist.turret2.on;
      coolantOff = (turret == 1) ? coolants.mist.turret1.off : coolants.mist.turret2.off;
      break;
    case COOLANT_SUCTION:
      if (!coolants.suction) {
        break;
      }
      m = (turret == 1) ? coolants.suction.turret1.on : coolants.suction.turret2.on;
      coolantOff = (turret == 1) ? coolants.suction.turret1.off : coolants.suction.turret2.off;
      break;
    case COOLANT_FLOOD_THROUGH_TOOL:
      if (!coolants.floodThroughTool) {
        break;
      }
      m = (turret == 1) ? coolants.floodThroughTool.turret1.on : coolants.floodThroughTool.turret2.on;
      coolantOff = (turret == 1) ? coolants.floodThroughTool.turret1.off : coolants.floodThroughTool.turret2.off;
      break;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  }

  if (m) {
    currentCoolantMode = coolant;
    var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(mFormat.format(m[i]));
      }
    } else {
      multipleCoolantBlocks.push(mFormat.format(m));
    }
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

function onCommand(command) {
  switch (command) {
    case COMMAND_COOLANT_OFF:
      setCoolant(COOLANT_OFF, machineState.currentTurret);
      break;
    case COMMAND_LOCK_MULTI_AXIS:
      writeBlock(currentSection.spindle == SPINDLE_PRIMARY ? getCode("CLAMP_PRIMARY_SPINDLE") : getCode("CLAMP_SECONDARY_SPINDLE")); // C-axis
      if (gotBAxis) {
        writeBlock(getCode("CLAMP_B_AXIS")); // B-axis
      }
      break;
    case COMMAND_UNLOCK_MULTI_AXIS:
      if (gotBAxis) {
        writeBlock(getCode("UNCLAMP_B_AXIS")); // B-axis
      }
      writeBlock(currentSection.spindle == SPINDLE_PRIMARY ? getCode("UNCLAMP_PRIMARY_SPINDLE") : getCode("UNCLAMP_SECONDARY_SPINDLE")); // C-axis
      break;
    case COMMAND_START_CHIP_TRANSPORT:
      // writeBlock(getCode("START_CHIP_TRANSPORT"));
      break;
    case COMMAND_STOP_CHIP_TRANSPORT:
      // writeBlock(getCode("STOP_CHIP_TRANSPORT"));
      break;
    case COMMAND_BREAK_CONTROL:
      break;
    case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
      break;
    case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
      break;
    case COMMAND_STOP:
      writeBlock(mFormat.format(0));
      forceSpindleSpeed = true;
      break;
    case COMMAND_OPTIONAL_STOP:
      writeBlock(mFormat.format(1));
      break;
    case COMMAND_END:
      writeBlock(mFormat.format(2));
      break;
    case COMMAND_SPINDLE_CLOCKWISE:
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
          writeBlock(getCode("START_MAIN_SPINDLE_CW"));
        } else {
          writeBlock(getCode("START_LIVE_TOOL_CW"));
        }
      } else {
        if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
          writeBlock(getCode("START_SUB_SPINDLE_CW"));
        } else {
          writeBlock(getCode("START_LIVE_TOOL_CW"));
        }
      }
      break;
    case COMMAND_SPINDLE_COUNTERCLOCKWISE:
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
          writeBlock(getCode("START_MAIN_SPINDLE_CCW"));
        } else {
          writeBlock(getCode("START_LIVE_TOOL_CCW"));
        }
      } else { // secondary
        if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
          writeBlock(getCode("START_SUB_SPINDLE_CCW"));
        } else {
          writeBlock(getCode("START_LIVE_TOOL_CCW"));
        }
      }
      break;
    case COMMAND_STOP_SPINDLE:
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
          writeBlock(getCode("STOP_MAIN_SPINDLE"));
        } else {
          writeBlock(getCode("STOP_LIVE_TOOL"));
        }
      } else {
        if (machineState.isTurningOperation || (machineState.axialCenterDrilling && !machineState.liveToolIsActive)) {
          writeBlock(getCode("STOP_SUB_SPINDLE"));
        } else {
          writeBlock(getCode("STOP_LIVE_TOOL"));
        }
      }
      break;
    default:
      onUnsupportedCommand(command);
  }
}

function engagePartCatcher(engage) {
  if (engage) {
    // catch part here
    writeBlock(getCode("PART_CATCHER_ON"), formatComment(localize("PART CATCHER ON")));
  } else {
    onCommand(COMMAND_COOLANT_OFF);
    writeRetract(X);
    writeRetract(Z);
    writeRetract(Y);
    writeBlock(getCode("PART_CATCHER_OFF"), formatComment(localize("PART CATCHER OFF")));
    forceXYZ();
  }
}

function onSectionEnd() {
  if (properties.useSmoothing) {
    setSmoothing(false);
  }

  if (machineState.usePolarMode) {
    setPolarMode(false); // disable polar interpolation mode
  }

  // cancel SFM mode to preserve spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(true, getFramePosition(currentSection.getFinalPosition()));
  }

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
    (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  if (hasNextSection()) {
    if (getNextSection().getTool().coolant != currentSection.getTool().coolant) {
      setCoolant(COOLANT_OFF, machineState.currentTurret);
    }
  }

  if (currentSection.isMultiAxis()) {
    //writeBlock(gFormat.format(49));
  }

  forceAny();
  forceXZCMode = false;
  forcePolarMode = false;
}

function onClose() {
  writeln("");

  optionalSection = false;

  onCommand(COMMAND_COOLANT_OFF);

  writeRetract(X);
  writeRetract(Z);
  writeRetract(Y);

  if (machineState.liveToolIsActive) {
    writeBlock(getCode("STOP_LIVE_TOOL"));
  } else if (machineState.mainSpindleIsActive) {
    writeBlock(getCode("STOP_MAIN_SPINDLE"));
  } else if (machineState.subSpindleIsActive) {
    writeBlock(getCode("STOP_SUB_SPINDLE"));
  } else {
    error(localize("Unknown machineState."));
    return;
  }
  if (machineState.tailstockIsActive) {
    writeBlock(getCode("TAILSTOCK_OFF"));
  }

  writeBlock(gFormat.format(69), writeDebugInfo("Cancel mirror mode for second revolver"));
  if (gotSecondarySpindle) {
    writeBlock(gSpindleModal.format(111), writeDebugInfo("Cancel cross machining control"));
  }
  writeln("");
  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
}
