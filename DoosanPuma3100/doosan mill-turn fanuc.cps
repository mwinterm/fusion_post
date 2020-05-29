/**
  Copyright (C) 2012-2020 by Autodesk, Inc.
  All rights reserved.

  Doosan Lathe post processor configuration.

  $Revision: 42715 bb7490cbf7744be0fe016711cd4e85bc17ebe8da $
  $Date: 2020-03-31 06:16:43 $

  FORKID {C7A4BD6C-CF7A-4299-BF94-3C18351E8FA7}
*/

///////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     partEject                  - Manually eject the part
//     transferType:phase,speed   - Phase or Speed spindle synchronization for stock-transfer
//     transferUseTorque:yes,no   - Use torque control for stock-transfer
//     useXZCMode                 - Force XZC mode for next operation
//     usePolarMode               - Force Polar mode for next operation
//     useTailStock:yes,no         - Use tailstock until canceled
//     syncSpindleStart:error, unclamp, speed   - Method to use when starting the spindle while they are connected/synched
//
///////////////////////////////////////////////////////////////////////////////

description = "Doosan Mill/Turn with Fanuc 31i control";
vendor = "Doosan";
vendorUrl = "https://www.doosanmachinetools.com";
legal = "Copyright (C) 2012-2020 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 40783;

longDescription = "Doosan lathe (Fanuc 31i control) post with support for mill-turn for use with Lynx and Puma.";

extension = "nc";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(120); // reduced sweep due to G112 support
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = false;
highFeedrate = (unit == IN) ? 470 : 12000;

// user-defined properties
properties = {
  writeMachine: true, // write machine
  writeTools: true, // writes the tools
  maxTool: 12,  // maximum tool number
  showSequenceNumbers: true, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 10, // increment for sequence numbers
  sequenceNumberToolOnly: false, // output sequence numbers on tool change only
  optionalStop: true, // optional stop
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: false, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  maximumSpindleSpeed: 2500, // specifies the maximum spindle speed
  useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: false, // specifies that operation notes should be output.
  useCycles: true, // specifies that drilling cycles should be used.
  gotPartCatcher: true, // specifies if the machine has a part catcher
  autoEject: "false", // specifies if the part should be automatically ejected at end of program
  useTailStock: "false", // specifies to use the tailstock or not
  gotChipConveyor: true, // specifies to use a chip conveyor Y/N
  useG28Zhome: false, // use G28 to move Z to its home position
  zHomePosition: 400, // home position for Z when useG28Zhome is false
  transferType: "Phase", // Phase, Speed, or Stop synchronization for stock-transfer
  optimizeCaxisSelect: false, // optimize output of enable/disable C-axis codes
  transferUseTorque: false, // use torque control for stock-transfer
  looping: false, //output program for M98 looping
  numberOfRepeats: 1, //how many times to loop program
  cutoffConfirmation: true, // use G350 after cutoff for parting confirmation
  writeVersion: false, // include version info
  useSimpleThread: true, // outputs a G92 threading cycle, false outputs a G76 (standard) threading cycle
  machineType: "PUMA", // type of machine "PUMA", "LYNX", "LYNX_YAXIS", "PUMA_MX"
  useG400: false, // use G400 for milling tools
  reverseAxes: true, // reverse YC-axes on sub-spindle
  useSpindlePcodes: true // use P11, P12, P13, etc. to specify the spindle, otherwise use unique M-codes
};

// user-defined property definitions
propertyDefinitions = {
  writeMachine: { title: "Write machine", description: "Output the machine settings in the header of the code.", group: 0, type: "boolean" },
  writeTools: { title: "Write tool list", description: "Output a tool list in the header of the code.", group: 0, type: "boolean" },
  maxTool: { title: "Max tool number", description: "Defines the maximum tool number.", type: "integer", range: [0, 999999999] },
  showSequenceNumbers: { title: "Use sequence numbers", description: "Use sequence numbers for each block of outputted code.", group: 1, type: "boolean" },
  sequenceNumberStart: { title: "Start sequence number", description: "The number at which to start the sequence numbers.", group: 1, type: "integer" },
  sequenceNumberIncrement: { title: "Sequence number increment", description: "The amount by which the sequence number is incremented by in each block.", group: 1, type: "integer" },
  sequenceNumberToolOnly: { title: "Sequence numbers only on tool change", description: "Output sequence numbers on tool changes instead of every line.", group: 1, type: "boolean" },
  optionalStop: { title: "Optional stop", description: "Outputs optional stop code during when necessary in the code.", type: "boolean" },
  separateWordsWithSpace: { title: "Separate words with space", description: "Adds spaces between words if 'yes' is selected.", type: "boolean" },
  useRadius: { title: "Radius arcs", description: "If yes is selected, arcs are outputted using radius values rather than IJK.", type: "boolean" },
  maximumSpindleSpeed: { title: "Max spindle speed", description: "Defines the maximum spindle speed allowed by your machines.", type: "integer", range: [0, 999999999] },
  useParametricFeed: { title: "Parametric feed", description: "Specifies the feed value that should be output using a Q value.", type: "boolean" },
  showNotes: { title: "Show notes", description: "Writes operation notes as comments in the outputted code.", type: "boolean" },
  useCycles: { title: "Use cycles", description: "Specifies if canned drilling cycles should be used.", type: "boolean" },
  gotPartCatcher: { title: "Use part catcher", description: "Specifies whether part catcher code should be output.", type: "boolean" },
  autoEject: {
    title: "Auto eject",
    description: "Specifies whether the part should automatically eject at the end of a program.  'Use coolant flush' will use flush coolant to eject the part instead of the part ejector.",
    type: "enum",
    values: [
      { title: "Yes", id: "true" },
      { title: "No", id: "false" },
      { title: "Use coolant flush", id: "flush" }
    ]
  },
  useTailStock: {
    title: "Use tailstock",
    description: "Specifies whether to use the tailstock or not.  'Sub spindle' will use a live center mounted in the sub spindle.",
    type: "enum",
    values: [
      { title: "Yes", id: "true" },
      { title: "No", id: "false" },
      { title: "In sub spindle", id: "subSpindle" },
      { title: "In sub spindle no torque", id: "noTorque" }
    ]
  },
  gotChipConveyor: { title: "Got chip conveyor", description: "Specifies whether to use a chip conveyor.", type: "boolean", presentation: "yesno" },
  useG28Zhome: { title: "Use G28 Z home", description: "Specifies whether to use a G28 Z home position.", type: "boolean", presentation: "yesno" },
  zHomePosition: { title: "Z home position", description: "Z home position, only output if Use G28 Z Home is not used.", type: "number" },
  transferType: { title: "Transfer type", description: "Phase, speed or stop synchronization for stock-transfer.", type: "enum", values: ["Phase", "Speed"] },
  optimizeCaxisSelect: { title: "Optimize C axis selection", description: "Optimizes the output of enable/disable C-axis codes.", type: "boolean" },
  transferUseTorque: { title: "Stock-transfer torque control", description: "Use torque control for stock transfer.", type: "boolean" },
  looping: { title: "Use M98 looping", description: "Output program for M98 looping.", type: "boolean", presentation: "yesno" },
  numberOfRepeats: { title: "Number of repeats", description: "How many times to loop the program.", type: "integer", range: [0, 99999999] },
  cutoffConfirmation: { title: "Use G350 parting confirmation", description: "Use G350 after cutoff for parting confirmation.", type: "boolean" },
  writeVersion: { title: "Write version", description: "Write the version number in the header of the code.", group: 0, type: "boolean" },
  useSimpleThread: { title: "Use simple threading cycle", description: "Enable to output G92 simple threading cycle, disable to output G76 standard threading cycle.", type: "boolean" },
  machineType: {
    title: "Machine type",
    description: "Select type of machine.",
    type: "enum",
    values: [
      { title: "Puma", id: "PUMA" },
      { title: "Lynx", id: "LYNX" },
      { title: "Lynx with Y-axis", id: "LYNX_YAXIS" },
      { title: "Puma MX", id: "PUMA_MX" }
    ]
  },
  useG400: { title: "Use G400 for milling tools", description: "Enable to output the G400 compensation block with milling/drilling operations. This option is only valid for the Puma MX model.", type: "boolean" },
  reverseAxes: { title: "Invert AC axes on sub-spindle", description: "Enable to reverse the Y and C axes when programming on the sub-spindle.  If you notice that the geometry is mirrored or conventional cutting on the machine, then disable this property.", type: "boolean" },
  useSpindlePcodes: { title: "Use P-codes for spindle selection", description: "Enable if P11, P12, etc. are used for spindle selection.  Disable if unique M-codes are used for spindle selection.", type: "boolean" }
};

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({ prefix: "G", decimals: 0 });
var g1Format = createFormat({ prefix: "G", decimals: 1, forceDecimal: false });
var mFormat = createFormat({ prefix: "M", decimals: 0 });
var spatialFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var xFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 2 }); // diameter mode & IS SCALING POLAR COORDINATES
var yFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var zFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var rFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true }); // radius
var abcFormat = createFormat({ decimals: 3, forceDecimal: true, scale: DEG });
var bFormat = createFormat({ prefix: "(B=", suffix: ")", decimals: 3, forceDecimal: true, scale: DEG });
var cFormat = createFormat({ decimals: 3, forceDecimal: true, scale: DEG, cyclicLimit: Math.PI * 2 });
var feedFormat = createFormat({ decimals: (unit == MM ? 2 : 3), forceDecimal: true });
var pitchFormat = createFormat({ decimals: 6, forceDecimal: true });
var toolFormat = createFormat({ decimals: 0, width: 4, zeropad: true });
var rpmFormat = createFormat({ decimals: 0 });
var secFormat = createFormat({ decimals: 3, forceDecimal: true }); // seconds - range 0.001-99999.999
var milliFormat = createFormat({ decimals: 0 }); // milliseconds // range 1-9999
var taperFormat = createFormat({ decimals: 1, scale: DEG });
var threadP1Format = createFormat({ decimals: 0, forceDecimal: false, trim: false, width: 6, zeropad: true });
var threadPQFormat = createFormat({ decimals: 0, forceDecimal: false, trim: true, scale: (unit == MM ? 1000 : 10000) });
var dwellFormat = createFormat({ prefix: "U", decimals: 3 });
// var peckFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var peckFormat = createFormat({ decimals: 0, forceDecimal: false, trim: false, width: 4, zeropad: true, scale: (unit == MM ? 1000 : 10000) });

var xOutput = createVariable({ prefix: "X" }, xFormat);
var yOutput = createVariable({ prefix: "Y" }, yFormat);
var zOutput = createVariable({ prefix: "Z" }, zFormat);
var aOutput = createVariable({ prefix: "A" }, abcFormat);
var bOutput = createVariable({}, bFormat);
var cOutput = createVariable({ prefix: "C" }, cFormat);
var subOutput = createVariable({ prefix: "B", force: true }, spatialFormat);
var feedOutput = createVariable({ prefix: "F" }, feedFormat);
var pitchOutput = createVariable({ prefix: "F", force: true }, pitchFormat);
var sOutput = createVariable({ prefix: "S", force: true }, rpmFormat);
var pOutput = createVariable({ prefix: "P", force: true }, rpmFormat);
var spOutput = createVariable({ prefix: "P", force: true }, rpmFormat);
var rOutput = createVariable({ prefix: "R", force: true }, rFormat);
var threadP1Output = createVariable({ prefix: "P", force: true }, threadP1Format);
var threadP2Output = createVariable({ prefix: "P", force: true }, threadPQFormat);
var threadQOutput = createVariable({ prefix: "Q", force: true }, threadPQFormat);
var threadROutput = createVariable({ prefix: "R", force: true }, threadPQFormat);
var g92ROutput = createVariable({ prefix: "R", force: true }, zFormat); // no scaling
var peckOutput = createVariable({ prefix: "Q", force: true }, peckFormat);

// circular output
var iOutput = createReferenceVariable({ prefix: "I", force: true }, spatialFormat);
var jOutput = createReferenceVariable({ prefix: "J", force: true }, spatialFormat);
var kOutput = createReferenceVariable({ prefix: "K", force: true }, spatialFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({ onchange: function () { gMotionModal.reset(); } }, gFormat); // modal group 2 // G17-19
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G98-99
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gSpindleModal = createModal({}, mFormat); // M176/177 SPINDLE MODE
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gPolarModal = createModal({}, g1Format); // G12.1, G13.1
var cAxisBrakeModal = createModal({}, mFormat);
var mInterferModal = createModal({}, mFormat);
var cAxisEngageModal = createModal({}, mFormat);
var gWCSModal = createModal({}, g1Format);
var tailStockModal = createModal({}, mFormat);

// fixed settings
var firstFeedParameter = 100;
var airCleanChuck = true; // use air to clean off chuck at part transfer and part eject

// defined in defineMachine
var gotYAxis;
var yAxisMinimum;
var yAxisMaximum;
var xAxisMinimum;
var gotBAxis;
var bAxisIsManual;
var gotMultiTurret;
var gotPolarInterpolation;
var gotSecondarySpindle;
var gotDoorControl;

var WARNING_WORK_OFFSET = 0;
var WARNING_REPEAT_TAPPING = 1;

var SPINDLE_MAIN = 0;
var SPINDLE_SUB = 1;
var SPINDLE_LIVE = 2;

var TRANSFER_PHASE = 0;
var TRANSFER_SPEED = 1;
var TRANSFER_STOP = 2;

// getSpindle parameters
var TOOL = false;
var PART = true;

// moveSubSpindle parameters
var HOME = 0;
var RAPID = 1;
var FEED = 2;
var TORQUE = 3;

// synchronized spindle start parameters
var SYNC_ERROR = 0;
var SYNC_UNCLAMP = 1;
var SYNC_SPEED = 2;

// clampChuck parameters
var CLAMP = true;
var UNCLAMP = false;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var previousSpindle = SPINDLE_MAIN;
var activeSpindle = SPINDLE_MAIN;
var partCutoff = false;
var transferType;
var transferUseTorque;
var reverseTap = false;
var showSequenceNumbers;
var forceXZCMode = false; // forces XZC output, activated by Action:useXZCMode
var forcePolarMode = false; // force Polar output, activated by Action:usePolarMode
var forceTailStock = false; // enable/disable TailStock
var tapping = false;
var ejectRoutine = false;
var bestABCIndex = undefined;
var headOffset = 0;
var lastSpindleMode = undefined;
var lastSpindleSpeed = 0;
var lastSpindleDirection = undefined;
var syncStartMethod = SYNC_ERROR; // method used to output spindle block when they are already synched/connected
var activeTurret = 1;

var machineState = {
  isTurningOperation: undefined,
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
  currentBAxisOrientationTurning: new Vector(0, 0, 0),
  mainChuckIsClamped: undefined,
  subChuckIsClamped: undefined,
  spindlesAreAttached: false,
  spindlesAreSynchronized: false,
  stockTransferIsActive: false,
  cAxesAreSynchronized: false
};

function getCode(code, spindle) {
  switch (code) {
    case "PART_CATCHER_ON":
      return 10;
    case "PART_CATCHER_OFF":
      return 11;
    case "TAILSTOCK_ON":
      machineState.tailstockIsActive = true;
      return 78;
    case "TAILSTOCK_OFF":
      machineState.tailstockIsActive = false;
      return 79;
    case "TAILSTOCK_CONTROL_ON":
      return 300;
    case "TAILSTOCK_CONTROL_OFF":
      return 301;
    case "SET_SPINDLE_FRAME":
      return (spindle == SPINDLE_MAIN) ? 80 : 83;
    case "ENABLE_C_AXIS":
      machineState.cAxisIsEngaged = true;
      return (spindle == SPINDLE_MAIN) ? 35 : 135;
    case "DISABLE_C_AXIS":
      machineState.cAxisIsEngaged = false;
      return (spindle == SPINDLE_MAIN) ? 34 : 134;
    case "POLAR_INTERPOLATION_ON":
      return 12.1;
    case "POLAR_INTERPOLATION_OFF":
      return 13.1;
    case "STOP_SPINDLE":
      if (properties.useSpindlePcodes) {
        return 5;
      } else {
        switch (spindle) {
          case SPINDLE_MAIN:
            return 5;
          case SPINDLE_LIVE:
            return 35;
          case SPINDLE_SUB:
            return 105;
        }
      }
      break;
    case "ORIENT_SPINDLE":
      return (spindle == SPINDLE_MAIN) ? 19 : 119;
    case "START_SPINDLE_CW":
      if (properties.useSpindlePcodes) {
        return 3;
      } else {
        switch (spindle) {
          case SPINDLE_MAIN:
            return 3;
          case SPINDLE_LIVE:
            return 33;
          case SPINDLE_SUB:
            return 103;
        }
      }
      break;
    case "START_SPINDLE_CCW":
      if (properties.useSpindlePcodes) {
        return 4;
      } else {
        switch (spindle) {
          case SPINDLE_MAIN:
            return 4;
          case SPINDLE_LIVE:
            return 34;
          case SPINDLE_SUB:
            return 104;
        }
      }
      break;
    case "FEED_MODE_MM_REV":
      return 99;
    case "FEED_MODE_MM_MIN":
      return 98;
    case "CONSTANT_SURFACE_SPEED_ON":
      return 96;
    case "CONSTANT_SURFACE_SPEED_OFF":
      return 97;
    case "AUTO_AIR_ON":
      return 14;
    case "AUTO_AIR_OFF":
      return 15;
    case "LOCK_MULTI_AXIS":
      return (spindle == SPINDLE_MAIN) ? 89 : 189;
    case "UNLOCK_MULTI_AXIS":
      return (spindle == SPINDLE_MAIN) ? 90 : 190;
    case "CLAMP_CHUCK":
      return (spindle == SPINDLE_MAIN) ? 68 : 168;
    case "UNCLAMP_CHUCK":
      return (spindle == SPINDLE_MAIN) ? 69 : 169;
    case "SPINDLE_SYNCHRONIZATION_PHASE":
      machineState.spindlesAreSynchronized = true;
      return 213;
    case "SPINDLE_SYNCHRONIZATION_SPEED":
      machineState.spindlesAreSynchronized = true;
      return 203;
    case "SPINDLE_SYNCHRONIZATION_OFF":
      machineState.spindlesAreSynchronized = false;
      return 205;
    case "CONNECT_C_AXES":
      machineState.cAxesAreSynchronized = true;
      return 136;
    case "DISCONNECT_C_AXES":
      machineState.cAxesAreSynchronized = false;
      return 137;
    case "TORQUE_SKIP_ON":
      return 86;
    case "TORQUE_SKIP_OFF":
      return 87;
    case "SELECT_SPINDLE":
      switch (spindle) {
        case SPINDLE_MAIN:
          machineState.mainSpindleIsActive = true;
          machineState.subSpindleIsActive = false;
          machineState.liveToolIsActive = false;
          return 11;
        case SPINDLE_LIVE:
          machineState.mainSpindleIsActive = false;
          machineState.subSpindleIsActive = false;
          machineState.liveToolIsActive = true;
          return 12;
        case SPINDLE_SUB:
          machineState.mainSpindleIsActive = false;
          machineState.subSpindleIsActive = true;
          machineState.liveToolIsActive = false;
          return 13;
      }
      break;
    case "RIGID_TAPPING":
      return 29;
    case "INTERLOCK_BYPASS":
      return (spindle == SPINDLE_MAIN) ? 31 : 131;
    case "INTERFERENCE_CHECK_OFF":
      return 110;
    case "INTERFERENCE_CHECK_ON":
      return 111;
    case "CYCLE_PART_EJECTOR":
      return 116;
    // coolant codes
    case "COOLANT_FLOOD_ON":
      return 8;
    case "COOLANT_FLOOD_OFF":
      return 9;
    case "COOLANT_MIST_ON":
      return 138;
    case "COOLANT_MIST_OFF":
      return 139;
    case "COOLANT_AIR_ON":
      return (spindle == SPINDLE_MAIN) ? 14 : 114;
    case "COOLANT_AIR_OFF":
      return (spindle == SPINDLE_MAIN) ? 15 : 115;
    case "COOLANT_THROUGH_TOOL_ON":
      switch (spindle) {
        case SPINDLE_MAIN:
          return 8;
        case SPINDLE_LIVE:
          return 8; // on some Doosan's it is 26
        //case SPINDLE_SUB:
        //  return 308; // on some Doosan's it is 208
      }
      break;
    case "COOLANT_THROUGH_TOOL_OFF":
      switch (spindle) {
        case SPINDLE_MAIN:
          return 9;
        case SPINDLE_LIVE:
          return 9;
        //case SPINDLE_SUB:
        //  return 309;
      }
      break;
    case "COOLANT_SUCTION_ON":
      return 7;
    case "COOLANT_OFF":
      return 9;
    default:
      error(localize("Command " + code + " is not defined."));
      return 0;
  }
  return 0;
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

function formatSequenceNumber() {
  if (sequenceNumber > 99999) {
    sequenceNumber = properties.sequenceNumberStart;
  }
  var seqno = "N" + sequenceNumber;
  sequenceNumber += properties.sequenceNumberIncrement;
  return seqno;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  var seqno = "";
  var opskip = "";
  if (showSequenceNumbers) {
    seqno = formatSequenceNumber();
  }
  if (optionalSection) {
    opskip = "/";
  }
  if (text) {
    writeWords(opskip, seqno, text);
  }
}

function writeDebug(_text) {
  writeComment("DEBUG - " + _text);
}

function formatComment(text) {
  return "(" + String(filterText(String(text).toUpperCase(), permittedCommentChars)).replace(/[()]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function getB(abc, section) {
  if (section.spindle == SPINDLE_PRIMARY) {
    return abc.y;
  } else {
    return Math.PI - abc.y;
  }
}

function writeCommentSeqno(text) {
  writeln(formatSequenceNumber() + formatComment(text));
}

function defineMachine() {
  machineConfiguration.setVendor("Doosan");
  if (properties.machineType == "PUMA") {
    machineConfiguration.setModel("3100LM");
    gotYAxis = false;
    yAxisMinimum = toPreciseUnit(-50, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(50, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(0, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotBAxis = false; // B-axis always requires customization to match the machine specific functions for doing rotations
    bAxisIsManual = true; // B-axis is manually set and not programmable
    gotMultiTurret = false; // specifies if the machine has several turrets
    gotPolarInterpolation = true; // specifies if the machine has XY polar interpolation capabilities
    gotSecondarySpindle = false;
    gotDoorControl = false;
    toolFormat = createFormat({ decimals: 0, width: 4, zeropad: true });
    properties.useG400 = false;
  } else if ((properties.machineType == "LYNX") || (properties.machineType == "LYNX_YAXIS")) {
    machineConfiguration.setModel("Lynx");
    if (properties.machineType == "LYNX_YAXIS") {
      gotYAxis = true;
      yAxisMinimum = toPreciseUnit(-52.5, MM); // specifies the minimum range for the Y-axis
      yAxisMaximum = toPreciseUnit(52.5, MM); // specifies the maximum range for the Y-axis
    } else {
      gotYAxis = false;
      yAxisMinimum = toPreciseUnit(0, MM); // specifies the minimum range for the Y-axis
      yAxisMaximum = toPreciseUnit(0, MM); // specifies the maximum range for the Y-axis
    }
    xAxisMinimum = toPreciseUnit(0, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotBAxis = false; // B-axis always requires customization to match the machine specific functions for doing rotations
    bAxisIsManual = true; // B-axis is manually set and not programmable
    gotMultiTurret = false; // specifies if the machine has several turrets
    gotPolarInterpolation = true; // specifies if the machine has XY polar interpolation capabilities
    gotSecondarySpindle = true;
    gotDoorControl = false;
    toolFormat = createFormat({ decimals: 0, width: 4, zeropad: true });
    properties.useG400 = false;
  } else if (properties.machineType == "PUMA_MX") {
    machineConfiguration.setModel("Puma MX");
    gotYAxis = true;
    yAxisMinimum = toPreciseUnit(-115, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(115, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-125, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotBAxis = true; // B-axis always requires customization to match the machine specific functions for doing rotations
    bAxisIsManual = false; // B-axis is manually set and not programmable
    gotMultiTurret = false; // specifies if the machine has several turrets
    gotPolarInterpolation = true; // specifies if the machine has XY polar interpolation capabilities
    gotSecondarySpindle = true;
    gotDoorControl = false;
    toolFormat = createFormat({ decimals: 0, width: 5, zeropad: true });
  } else {
    error(localize("Machine type must be 'Puma', 'Lynx', 'Lynx with Y-Axis', or 'Puma MX"));
  }

  // define B-axis
  if (gotBAxis) {
    if (bAxisIsManual) {
      bFormat = createFormat({ prefix: "(B=", suffix: ")", decimals: 3, forceDecimal: true, scale: DEG });
      bOutput = createVariable({}, bFormat);
      gWCSModal.format(69.1);
    } else {
      bFormat = createFormat({ prefix: "B", decimals: 3, forceDecimal: true, scale: DEG });
      bOutput = createVariable({}, bFormat);
      subOutput = createVariable({ prefix: "A", force: true }, spatialFormat);
      gWCSModal.format(369);
    }
  }
}

var machineConfigurationMainSpindle;
var machineConfigurationSubSpindle;

var machineConfigurationZ;
var machineConfigurationXC;
var machineConfigurationXB;

function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }
  if (!properties.useSpindlePcodes) {
    spOutput.disable();
  }

  // Copy certain properties into global variables
  showSequenceNumbers = properties.sequenceNumberToolOnly ? false : properties.showSequenceNumbers;
  transferType = parseToggle(properties.transferType, "PHASE", "SPEED");
  if (transferType == undefined) {
    error(localize("TransferType must be Phase or Speed"));
    return;
  }
  transferUseTorque = properties.transferUseTorque;

  // Setup default M-codes
  mInterferModal.format(getCode("INTERFERENCE_CHECK_ON", SPINDLE_MAIN));

  if (true) {
    var bAxisMain = createAxis({ coordinate: 1, table: false, axis: [0, -1, 0], range: [-90, 45], preference: 0 });
    var cAxisMain = createAxis({ coordinate: 2, table: true, axis: [0, 0, 1], cyclic: true, preference: 0 }); // C axis is modal between primary and secondary spindle

    var bAxisSub = createAxis({ coordinate: 1, table: false, axis: [0, 1, 0], range: [-45, 90], preference: 0 });
    var cAxisSub = createAxis({ coordinate: 2, table: true, axis: [0, 0, 1], cyclic: true, preference: 0 }); // C axis is modal between primary and secondary spindle

    machineConfigurationMainSpindle = gotBAxis ? new MachineConfiguration(bAxisMain, cAxisMain) : new MachineConfiguration(cAxisMain);
    machineConfigurationSubSpindle = gotBAxis ? new MachineConfiguration(bAxisSub, cAxisSub) : new MachineConfiguration(cAxisSub);
    machineConfigurationMainTurret2 = new MachineConfiguration(cAxisMain);
    machineConfigurationSubTurret2 = new MachineConfiguration(cAxisSub);
  }

  machineConfiguration = new MachineConfiguration(); // creates an empty configuration to be able to set eg vendor information
  defineMachine();

  if (!gotYAxis) {
    yOutput.disable();
  }
  aOutput.disable();
  if (!gotBAxis) {
    bOutput.disable();
  }

  if (highFeedrate <= 0) {
    error(localize("You must set 'highFeedrate' because axes are not synchronized for rapid traversal."));
    return;
  }

  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }

  sequenceNumber = properties.sequenceNumberStart;
  writeln("%");

  if (programName) {
    var programId;
    try {
      programId = getAsInt(programName);
    } catch (e) {
      error(localize("Program name must be a number."));
      return;
    }
    if (!((programId >= 1) && (programId <= 9999))) {
      error(localize("Program number is out of range."));
      return;
    }
    var oFormat = createFormat({ width: 4, zeropad: true, decimals: 0 });
    if (programComment) {
      writeln("O" + oFormat.format(programId) + " (" + filterText(String(programComment).toUpperCase(), permittedCommentChars) + ")");
    } else {
      writeln("O" + oFormat.format(programId));
    }
  } else {
    error(localize("Program name has not been specified."));
    return;
  }

  //write program generation date and time
  let current_datetime = new Date();
  let formatted_date = current_datetime.getDate() + "." + current_datetime.getMonth() + "." + current_datetime.getFullYear() + " - " + current_datetime.getHours() + ":" + current_datetime.getMinutes() + ":" + current_datetime.getSeconds();
  var date = current_datetime.getDate();
  var month = current_datetime.getMonth() + 1;
  var year = current_datetime.getFullYear();
  var hours = current_datetime.getHours();
  var minutes = current_datetime.getMinutes();
  var seconds = current_datetime.getSeconds();
  yearFormatted = year;
  monthFormatted = month < 10 ? "0" + month : month;
  dateFormatted = date < 10 ? "0" + date : date;
  hoursFormatted = hours < 10 ? "0" + hours : hours;
  minutesFormatted = minutes < 10 ? "0" + minutes : minutes;
  secondsFormatted = seconds < 10 ? "0" + seconds : seconds;
  writeln("");
  writeComment("Program created " + yearFormatted + "-" + monthFormatted + "-" + dateFormatted + "  " + hoursFormatted + "-" + minutesFormatted + "-" + secondsFormatted);
  writeln("");

  if (properties.writeVersion) {
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate());
    }
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (properties.writeMachine && (vendor || model || description)) {
    writeComment(localize("--- Machine ---"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": " + description);
    }
    writeln("");
  }

  // dump tool information
  if (properties.writeTools) {
    writeComment("--- TOOL LIST ---");
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
        var comment = "T" + toolFormat.format(tool.number * 100 + compensationOffset % 100) + " " +
          "D=" + spatialFormat.format(tool.diameter) + " " +
          (tool.diameter != 0 ? "D=" + spatialFormat.format(tool.diameter) + " " : "") +
          (tool.isTurningTool() ? localize("NR") + "=" + spatialFormat.format(tool.noseRadius) : localize("CR") + "=" + spatialFormat.format(tool.cornerRadius)) +
          (tool.taperAngle > 0 && (tool.taperAngle < Math.PI) ? " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg") : "") +
          (zRanges[tool.number] ? " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum()) : "") +
          " - " + localize(getToolTypeName(tool.type));
        writeComment(comment);
      }
    }
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

  // support program looping for bar work
  if (properties.looping) {
    if (properties.numberOfRepeats < 1) {
      error(localize("numberOfRepeats must be greater than 0."));
      return;
    }
    if (sequenceNumber == 1) {
      sequenceNumber++;
    }
    writeln("");
    writeln("");
    writeComment(localize("Local Looping"));
    writeln("");
    writeBlock(mFormat.format(98), "Q1", "L" + properties.numberOfRepeats);
    writeBlock(mFormat.format(30));
    writeln("");
    writeln("");
    writeln("N1 (START MAIN PROGRAM)");
  }

  { // stock - workpiece
    writeln("");
    if ((getGlobalParameter("stock-upper-x") > 0)) {
      writeBlock("G55 G1900 D" + spatialFormat.format(getGlobalParameter("stock-upper-x") * 2) +
        " L" + spatialFormat.format(-(getGlobalParameter("part-lower-z"))) +
        " K" + spatialFormat.format(-(getGlobalParameter("part-upper-z"))));
    }
  }

  if (properties.machineType == "PUMA_MX") {
    writeBlock(
      gFormat.format(0),
      gFormat.format(18),
      gUnitModal.format((unit == IN) ? 20 : 21),
      gFormat.format(40),
      gFormat.format(54),
      gFormat.format(80),
      gFormat.format(99),
      mFormat.format(getCode("INTERFERENCE_CHECK_OFF", SPINDLE_MAIN))
    );
  } else {
    switch (unit) {
      case IN:
        writeBlock(gUnitModal.format(20));
        break;
      case MM:
        writeBlock(gUnitModal.format(21));
        break;
    }
    if (gotSecondarySpindle) {
      writeBlock(mFormat.format(getCode("INTERFERENCE_CHECK_OFF", SPINDLE_MAIN)));
    }
  }

  if (properties.gotChipConveyor) {
    onCommand(COMMAND_START_CHIP_TRANSPORT);
  }

  // automatically eject part at end of program
  if (properties.autoEject != "false") {
    ejectRoutine = true;
  }

  // determine starting spindle
  switch (getSection(0).spindle) {
    case SPINDLE_PRIMARY: // main spindle
      activeSpindle = SPINDLE_MAIN;
      machineState.mainChuckIsClamped = true;
      break;
    case SPINDLE_SECONDARY: // sub spindle
      activeSpindle = SPINDLE_SUB;
      machineState.subChuckIsClamped = true;
      break;
  }
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
  previousDPMFeed = 0;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function forceUnlockMultiAxis() {
  cAxisBrakeModal.reset();
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

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function cancelWorkPlane() {
  cancelTransformation();
  if (gotBAxis && (activeTurret != 2)) {
    if (bAxisIsManual) {
      writeBlock(gWCSModal.format(69.1));
    } else {
      writeBlock(gWCSModal.format(369));
    }
  }
}

function getTCP(abc) {
  tcp = (gotBAxis && activeTurret != 2) &&
    (machineState.axialCenterDrilling ||
      (properties.useG400 && (Math.abs(bFormat.getResultingValue(abc.y)) == 90)) ||
      (machineState.usePolarMode || machineState.useXZCMode));
  return tcp;
}

function setWorkPlane(abc) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
    abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
    abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
    abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  if ((gotBAxis && (activeTurret != 2)) && (abc.y != 0)) {
    if (bAxisIsManual) {
      writeBlock(
        gMotionModal.format(0),
        conditional(machineConfiguration.isMachineCoordinate(0), aOutput.format(abc.x)),
        conditional(machineConfiguration.isMachineCoordinate(1), bFormat.format(abc.y)),
        conditional(machineConfiguration.isMachineCoordinate(2), cOutput.format(abc.z))
      );
      writeBlock(gWCSModal.format(68.1),
        "X" + spatialFormat.format(0),
        conditional(gotYAxis, "Y" + spatialFormat.format(0)),
        "Z" + spatialFormat.format(0),
        "I" + spatialFormat.format(0),
        "J" + spatialFormat.format(1),
        "K" + spatialFormat.format(0),
        "R" + abcFormat.format((getSpindle(PART) == SPINDLE_MAIN) ? abc.y : -abc.y)
      );
    } else {
      if (properties.useG400 && ((bFormat.getResultingValue(abc.y) == 0) || (Math.abs(bFormat.getResultingValue(abc.y)) == 90))) {
        setSpindleOrientationMilling(abc);
      } else {
        var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
        var toolAxisMode = (machineState.usePolarMode || machineState.useXZCMode || machineState.axialCenterDrilling) ? 0 : 1;  // D0 = tool axis is Z-axis, D1 = tool axis is X-axis
        writeBlock(
          gWCSModal.format(368),
          "X" + spatialFormat.format(0),
          "Z" + spatialFormat.format(0),
          "D" + spatialFormat.format(toolAxisMode),
          bFormat.format((getSpindle(PART) == SPINDLE_MAIN) ? abc.y : -abc.y), // only B-axis is supported for G368
          "W" + compensationOffset
        );
      }
      if ((getSpindle(TOOL) == SPINDLE_LIVE) && machineConfiguration.isMachineCoordinate(2)) {
        writeBlock(gMotionModal.format(0), cOutput.format(abc.z));
      }
    }
  } else {
    if (properties.useG400 && (activeTurret != 2)) {
      setSpindleOrientationMilling(abc);
      if ((getSpindle(TOOL) == SPINDLE_LIVE) && machineConfiguration.isMachineCoordinate(2)) {
        writeBlock(gMotionModal.format(0), cOutput.format(abc.z));
      }
    } else {
      writeBlock(
        gMotionModal.format(0),
        conditional(machineConfiguration.isMachineCoordinate(0), aOutput.format(abc.x)),
        conditional(machineConfiguration.isMachineCoordinate(1), bFormat.format(abc.y)),
        conditional(machineConfiguration.isMachineCoordinate(2), cOutput.format(abc.z))
      );
    }
  }

  if (!machineState.usePolarMode && !machineState.useXZCMode && !currentSection.isMultiAxis() &&
    (getSpindle(TOOL) == SPINDLE_LIVE)) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
  }

  currentWorkPlaneABC = new Vector(abc.x, abc.y, abc.z);
  previousABC = new Vector(abc.x, abc.y, abc.z);
}

function getBestABC(section, workPlane, which) {
  var W = workPlane;
  var abc = machineConfiguration.getABC(W);
  if (which == undefined) { // turning, XZC, Polar modes
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
          x = box.lower.x + ((box.upper.x - box.lower.x) / 2);
          y = box.lower.y + ((box.upper.y - box.lower.y) / 2);
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
          var tempABC = new Vector(0, 0, 0); // don't use B-axis in calculation
          tempABC.setCoordinate(ix, abc.getCoordinate(ix));
          var R = machineConfiguration.getRemainingOrientation(tempABC, W);
          x = R.right.x;
          y = R.right.y;
          break;
      }
      abc.setCoordinate(ix, getCClosest(x, y, cOutput.getCurrent()));
    }
  }
  return abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(section, workPlane) {
  var W = workPlane; // map to global frame

  var abc;
  if (machineState.isTurningOperation && gotBAxis) {
    var both = machineConfiguration.getABCByDirectionBoth(workPlane.forward);
    abc = both[0];
    if (both[0].z != 0) {
      abc = both[1];
    }
  } else {
    abc = getBestABC(section, workPlane, bestABCIndex);
    if (closestABC) {
      if (currentMachineABC) {
        abc = machineConfiguration.remapToABC(abc, currentMachineABC);
      } else {
        abc = machineConfiguration.getPreferredABC(abc);
      }
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " " + bFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + cFormat.format(abc.z))
    );
    return abc;
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
    return abc;
  }

  if (machineState.isTurningOperation && gotBAxis) { // remapABC can change the B-axis orientation
    if (abc.z != 0) {
      error(localize("Could not calculate a B-axis turning angle within the range of the machine."));
      return abc;
    }
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " " + bFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + cFormat.format(abc.z))
    );
    return abc;
  }

  var tcp = getTCP(abc);
  if (tcp) {
    setRotation(W); // TCP mode
  } else {
    var O = machineConfiguration.getOrientation(abc);
    var R = machineConfiguration.getRemainingOrientation(abc, W);
    setRotation(R);
  }
  return abc;
}

var bAxisOrientationTurning = new Vector(0, 0, 0);

function setSpindleOrientationTurning(insertToolCall) {
  cancelTransformation();
  var leftHandtool;
  if (hasParameter("operation:tool_hand")) {
    if (getParameter("operation:tool_hand") == "L") { // TAG: add neutral tool to Left hand case
      if (getParameter("operation:tool_holderType") == 0) {
        leftHandtool = false;
      } else {
        leftHandtool = true;
      }
    } else {
      leftHandtool = false;
    }
  }
  var J;
  var R;
  var spindleMain = getSpindle(PART) == SPINDLE_MAIN;

  if (hasParameter("operation:turningMode") && (getParameter("operation:turningMode") == "front")) {
    if ((getParameter("operation:direction") == "front to back")) {
      R = spindleMain ? 2 : 1;
    } else {
      R = spindleMain ? 3 : 4;
    }
  } else if (hasParameter("operation:machineInside")) {
    if (getParameter("operation:machineInside") == 0) {
      R = spindleMain ? 3 : 4;
    } else {
      R = spindleMain ? 2 : 1;
    }
  } else {
    if ((hasParameter("operation-strategy") && (getParameter("operation-strategy") == "turningFace") ||
      (hasParameter("operation-strategy") && (getParameter("operation-strategy") == "turningPart")))) {
      R = spindleMain ? 3 : 4;
    } else {
      error(localize("Failed to identify R-value for G400 for Operation " + "\"" + (getParameter("operation-comment").toUpperCase()) + "\""));
      return;
    }
  }
  if (leftHandtool) {
    J = spindleMain ? 2 : 1;
  } else {
    J = spindleMain ? 1 : 2;
  }
  if ((bAxisOrientationTurning.y < machineConfiguration.getAxisU().getRange().getMinimum()) ||
    (bAxisOrientationTurning.y > machineConfiguration.getAxisU().getRange().getMaximum())) {
    error(localize("B-Axis Orientation is out of range in operation " + "\"" + (getParameter("operation-comment").toUpperCase()) + "\""));
  }

  if (insertToolCall || machineState.currentBAxisOrientationTurning.y != bAxisOrientationTurning.y || (previousSpindle != getSpindle(PART))) {
    if (spindleMain) {
      var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
    } else {
      var compensationOffset = (tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset) + 100;
    }
    if (!spindleMain) {
      bAxisOrientationTurning.y *= -1;
    }
    writeBlock(gFormat.format(400), "B" + spatialFormat.format(toDeg(bAxisOrientationTurning.y)), "J" + spatialFormat.format(J), "R" + spatialFormat.format(R));
  }
  machineState.currentBAxisOrientationTurning.y = Math.abs(bAxisOrientationTurning.y);
}

function getBAxisOrientationTurning(section) {
  var toolAngle = hasParameter("operation:tool_angle") ? getParameter("operation:tool_angle") : 0;
  var toolOrientation = section.toolOrientation;
  if (toolAngle && toolOrientation != 0) {
    // error(localize("You cannot use tool angle and tool orientation together in operation " + "\"" + (getParameter("operation-comment")) + "\""));
  }

  var angle = toRad(toolAngle) + toolOrientation;

  var axis = new Vector(0, 1, 0);
  var mappedAngle = (currentSection.spindle == SPINDLE_PRIMARY ? (Math.PI / 2 - angle) : (Math.PI / 2 - angle));
  var mappedWorkplane = new Matrix(axis, mappedAngle);
  var abc = getWorkPlaneMachineABC(section, mappedWorkplane);
  return abc;
}

function setSpindleOrientationMilling(abc) {
  if (properties.useG400) {
    var J;
    switch (getSpindle(TOOL)) {
      case SPINDLE_MAIN:
        J = 1;
        break;
      case SPINDLE_SUB:
        J = 2;
        break;
      case SPINDLE_LIVE:
        J = 0;
        break;
    }
    bOutput.reset();
    writeBlock(gFormat.format(400), bOutput.format(getB(abc, currentSection)), "J" + spatialFormat.format(J));
    writeBlock(mFormat.format(101)); // clamp B-axis
  } else {
    if (gWCSModal.getCurrent() != 369) { // TAG: Move to not useG400
      writeBlock(gFormat.format(369));
    }
    bOutput.reset();
    writeBlock(gMotionModal.format(0), bOutput.format(getB(abc, currentSection)));
  }
}

function getSpindle(whichSpindle) {
  // safety conditions
  if (getNumberOfSections() == 0) {
    return SPINDLE_MAIN;
  }
  if (getCurrentSectionId() < 0) {
    if (machineState.liveToolIsActive && (whichSpindle == TOOL)) {
      return SPINDLE_LIVE;
    } else {
      return getSection(getNumberOfSections() - 1).spindle;
    }
  }

  // Turning is active or calling routine requested which spindle part is loaded into
  if (machineState.isTurningOperation || machineState.axialCenterDrilling || (whichSpindle == PART)) {
    return currentSection.spindle;
    //Milling is active
  } else {
    return SPINDLE_LIVE;
  }
}

function getSecondarySpindle() {
  var spindle = getSpindle(PART);
  return (spindle == SPINDLE_MAIN) ? SPINDLE_SUB : SPINDLE_MAIN;
}

/** Invert YZC axes for the sub-spindle. */
function invertAxes(activate, polarMode) {
  if (activate) {
    var scaleValue = properties.reverseAxes ? -1 : 1;
    var yAxisPrefix = polarMode ? "C" : "Y";
    yFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: (1 * scaleValue) });
    zFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: -1 });
    zOutput = createVariable({ prefix: "Z" }, zFormat);
    if (polarMode) {
      yOutput = createVariable({ prefix: "C" }, yFormat);
      cOutput.disable();
    } else {
      yOutput = createVariable({ prefix: "Y" }, yFormat);
      cFormat = createFormat({ decimals: 4, forceDecimal: true, scale: (DEG * scaleValue), cyclicLimit: Math.PI * 2 });
      cOutput = createVariable({ prefix: "C" }, cFormat);
    }
    jOutput = createReferenceVariable({ prefix: "J", force: true }, yFormat);
    kOutput = createReferenceVariable({ prefix: "K", force: true }, yFormat);
  } else {
    xFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 2 });
    yFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 1 });
    zFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 1 });
    cFormat = createFormat({ decimals: 4, forceDecimal: true, scale: DEG, cyclicLimit: Math.PI * 2 });
    xOutput = createVariable({ prefix: "X" }, xFormat);
    yOutput = createVariable({ prefix: "Y" }, yFormat);
    zOutput = createVariable({ prefix: "Z" }, zFormat);
    cOutput = createVariable({ prefix: "C" }, cFormat);
    iOutput = createReferenceVariable({ prefix: "I", force: true }, spatialFormat);
    jOutput = createReferenceVariable({ prefix: "J", force: true }, spatialFormat);
    kOutput = createReferenceVariable({ prefix: "K", force: true }, spatialFormat);
  }
}

function isPerpto(a, b) {
  return Math.abs(Vector.dot(a, b)) < (1e-7);
}

function onSection() {
  /** Handle multiple turrets. */
  if (gotMultiTurret) {
    activeTurret = tool.turret;
    if (activeTurret == 0) {
      warningOnce(localize("Turret has not been specified. Using Turret 1 as default."));
      activeTurret = 1; // upper turret as default
    }
    switch (activeTurret) {
      case 1:
        activeTurret = 1;
        break;
      case 2:
        activeTurret = 2;
        break;
      default:
        error(localize("Turret is not supported."));
        return;
    }
  }

  // Detect machine configuration
  if (activeTurret == 2) {
    machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainTurret2 : machineConfigurationSubTurret2;
  } else {
    machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainSpindle : machineConfigurationSubSpindle;
  }
  if (!gotBAxis || bAxisIsManual || (activeTurret == 2)) {
    if ((getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) && !currentSection.isMultiAxis()) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(1, 0, 0));
    }
  } else {
    machineConfiguration.setSpindleAxis(new Vector(1, 0, 0)); // set the spindle axis depending on B0 orientation
  }

  setMachineConfiguration(machineConfiguration);
  currentSection.optimizeMachineAnglesByMachine(machineConfiguration, 2); // map tip mode

  // Define Machining modes
  tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
      (getParameter("operation:cycleType") == "right-tapping") ||
      (getParameter("operation:cycleType") == "left-tapping") ||
      (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  bestABCIndex = undefined;

  machineState.isTurningOperation = (currentSection.getType() == TYPE_TURNING);
  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  var retracted = false; // specifies that the tool has been retracted to the safe plane

  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (machineState.isTurningOperation &&
      abcFormat.areDifferent(bAxisOrientationTurning.x, machineState.currentBAxisOrientationTurning.x) ||
      abcFormat.areDifferent(bAxisOrientationTurning.y, machineState.currentBAxisOrientationTurning.y) ||
      abcFormat.areDifferent(bAxisOrientationTurning.z, machineState.currentBAxisOrientationTurning.z));

  partCutoff = hasParameter("operation-strategy") &&
    (getParameter("operation-strategy") == "turningPart");

  var yAxisWasEnabled = !machineState.useXZCMode && !machineState.usePolarMode && machineState.liveToolIsActive;
  updateMachiningMode(currentSection); // sets the needed machining mode to machineState (usePolarMode, useXZCMode, axialCenterDrilling)

  // Get the active spindle
  var newSpindle = true;
  var tempSpindle = getSpindle(TOOL);
  var forceSpindle = false;
  if (isFirstSection()) {
    previousSpindle = tempSpindle;
  }
  newSpindle = tempSpindle != previousSpindle;

  headOffset = tool.getBodyLength();
  // End the previous section if a new tool is selected
  if (!isFirstSection() && insertToolCall) {
    if (machineState.spindlesAreSynchronized) {
      if (!machineState.spindlesAreAttached) {
        onCommand(COMMAND_STOP_SPINDLE);
      }
    } else {
      if (previousSpindle == SPINDLE_LIVE) {
        onCommand(COMMAND_STOP_SPINDLE);
        forceUnlockMultiAxis();
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
        if ((tempSpindle != SPINDLE_LIVE) && !properties.optimizeCaxisSelect) {
          cAxisEngageModal.reset();
          writeBlock(cAxisEngageModal.format(getCode("DISABLE_C_AXIS", getSpindle(PART))));
        }
      } else {
        if (tool.clockwise != getPreviousSection().getTool().clockwise) {
          forceSpindle = true;
          onCommand(COMMAND_STOP_SPINDLE);
        }
      }
    }
    onCommand(COMMAND_COOLANT_OFF);
    goHome();
    mInterferModal.reset();
    if (gotSecondarySpindle) {
      writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(PART))));
    }
    if (properties.optionalStop) {
      onCommand(COMMAND_OPTIONAL_STOP);
      gMotionModal.reset();
      forceSpindle = true;
    }
  }
  // Consider part cutoff as stockTransfer operation
  if (!(machineState.stockTransferIsActive && partCutoff)) {
    machineState.stockTransferIsActive = false;
  }

  // Cancel the reverse spindle code used in tapping
  if (reverseTap) {
    writeBlock(mFormat.format(177));
    reverseTap = false;
  }

  // cancel previous work plane
  if (insertToolCall || newWorkPlane) {
    cancelWorkPlane();
  }

  // Output the operation description
  writeln("");
  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      if (insertToolCall && properties.sequenceNumberToolOnly) {
        writeCommentSeqno(comment);
      } else {
        writeComment(comment);
      }
    }
  }

  // invert axes for secondary spindle
  if (getSpindle(PART) == SPINDLE_SUB) {
    invertAxes(true, false); // polar mode has not been enabled yet
  }

  // Position all axes at home
  if (insertToolCall && !machineState.stockTransferIsActive) {
    moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", false);
    goHome();

    // Stop the spindle
    if (newSpindle) {
      onCommand(COMMAND_STOP_SPINDLE);
    }
  }

  // Setup WCS code
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = currentSection.workOffset;
  if (workOffset == 0) {
    warningOnce(localize("Work offset has not been specified. Using G54 as WCS."), WARNING_WORK_OFFSET);
    workOffset = 1;
  }
  var wcsOut = "";
  if (workOffset > 0) {
    if (workOffset > 6) {
      error(localize("Work offset out of range."));
      return;
    } else {
      if (workOffset != currentWorkOffset) {
        forceWorkPlane();
        wcsOut = gFormat.format(53 + workOffset); // G54->G59
        currentWorkOffset = workOffset;
      }
    }
  }

  // Get active feedrate mode
  if (insertToolCall) {
    gFeedModeModal.reset();
  }
  var feedMode;
  if ((currentSection.feedMode == FEED_PER_REVOLUTION) || tapping) {
    feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_REV", getSpindle(TOOL)));
  } else {
    feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL)));
  }

  // Live Spindle is active
  if (tempSpindle == SPINDLE_LIVE) {
    if (insertToolCall || wcsOut || feedMode) {
      forceUnlockMultiAxis();
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      var plane = getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL ? getG17Code() : 18;
      gPlaneModal.reset();
      if (!properties.optimizeCaxisSelect) {
        cAxisEngageModal.reset();
      }
      writeBlock(wcsOut/*, mFormat.format(getCode("SET_SPINDLE_FRAME", getSpindle(PART)))*/);
      if (!machineState.spindlesAreAttached) {
        writeBlock(feedMode, gPlaneModal.format(plane), cAxisEngageModal.format(getCode("ENABLE_C_AXIS", getSpindle(PART))));
        writeBlock(gMotionModal.format(0), gFormat.format(28), "H" + abcFormat.format(0)); // unwind c-axis
        if (!machineState.usePolarMode && !machineState.useXZCMode && !currentSection.isMultiAxis()) {
          onCommand(COMMAND_LOCK_MULTI_AXIS);
        }
      } else {
        writeBlock(feedMode, gPlaneModal.format(plane));
      }
    } else {
      if (machineState.usePolarMode || machineState.useXZCMode || currentSection.isMultiAxis()) {
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      }
    }

    // Turning is active
  } else {
    if ((insertToolCall || wcsOut || feedMode) && !machineState.stockTransferIsActive) {
      forceUnlockMultiAxis();
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      gPlaneModal.reset();
      if (!properties.optimizeCaxisSelect) {
        cAxisEngageModal.reset();
      }
      writeBlock(wcsOut/*, mFormat.format(getSpindle(PART) == SPINDLE_SUB ? 83 : 80)*/);
      writeBlock(feedMode, gPlaneModal.format(18), cAxisEngageModal.format(getCode("DISABLE_C_AXIS", getSpindle(PART))));
    } else {
      writeBlock(feedMode);
    }
  }

  // Write out maximum spindle speed
  if (insertToolCall && !machineState.stockTransferIsActive) {
    if ((tool.maximumSpindleSpeed > 0) && (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
      var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
      writeBlock(gFormat.format(50), sOutput.format(maximumSpindleSpeed));
      sOutput.reset();
    }
  }

  // Write out notes
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

  switch (getMachiningDirection(currentSection)) {
    case MACHINING_DIRECTION_AXIAL:
      // writeBlock(gPlaneModal.format(getG17Code()));
      break;
    case MACHINING_DIRECTION_RADIAL:
      if (gotBAxis && (activeTurret != 2)) {
        // writeBlock(gPlaneModal.format(getG17Code()));
      } else {
        // writeBlock(gPlaneModal.format(getG17Code())); // RADIAL
      }
      break;
    case MACHINING_DIRECTION_INDEXING:
      // writeBlock(gPlaneModal.format(getG17Code())); // INDEXING
      break;
    default:
      error(subst(localize("Unsupported machining direction for operation " + "\"" + "%1" + "\"" + "."), getOperationComment()));
      return;
  }

  var abc;
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineState.isTurningOperation) {
      if (gotBAxis && (activeTurret != 2)) {
        cancelTransformation();
        // handle B-axis support for turning operations here
        bAxisOrientationTurning = getBAxisOrientationTurning(currentSection);
        abc = bAxisOrientationTurning;
      } else {
        abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
      }
    } else {
      if (currentSection.isMultiAxis()) {
        forceWorkPlane();
        cancelTransformation();
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
        abc = currentSection.getInitialToolAxisABC();
      } else {
        abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
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

  if (insertToolCall) {
    forceWorkPlane();
    retracted = true;
    onCommand(COMMAND_COOLANT_OFF);

    var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
    if (compensationOffset > 99) {
      error(localize("Compensation offset is out of range."));
      return;
    }

    if (tool.number > properties.maxTool) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if (tool.number == 0) {
      error(localize("Tool number cannot be 0"));
      return;
    }

    gMotionModal.reset();
    if (properties.machineType == "PUMA_MX") {
      if (isFirstSection() && (activeTurret != 2)) { // preselect first tool
        writeBlock("T" + toolFormat.format(tool.number * 1000));
      }
      writeBlock(conditional(activeTurret != 2, mFormat.format(6)), "T" + toolFormat.format(tool.number * 1000));
      var nextTool = getNextTool(tool.number);
      if (nextTool && (nextTool.turret != 2)) {
        writeBlock("T" + toolFormat.format(nextTool.number * 1000), formatComment("NEXT TOOL"));
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if ((tool.number != firstToolNumber) && (section.getTool().turret != 2)) {
          writeBlock("T" + toolFormat.format(firstToolNumber * 1000), formatComment("NEXT TOOL"));
        }
      }
      writeBlock("T" + toolFormat.format(tool.number * 1000 + compensationOffset));
    } else {
      writeBlock("T" + toolFormat.format(tool.number * 100 + compensationOffset));
    }
    if (tool.comment) {
      writeComment(tool.comment);
    }

    // Disable/Enable Spindle C-axis switching
    // The Doosan machine does not support C-axis switching
    // The X-axis has to be inverted when the secondary spindle is enabled
    /*
    if (getSpindle(TOOL) == SPINDLE_LIVE) {
      if (gotSecondarySpindle) {
        switch (currentSection.spindle) {
        case SPINDLE_PRIMARY: // main spindle
          writeBlock(gSpindleModal.format(177));
          break;
        case SPINDLE_SECONDARY: // sub spindle
          writeBlock(gSpindleModal.format(176));
          break;
        }
      }
    }
*/
  }

  // Turn on coolant
  setCoolant(tool.coolant);

  // Activate part catcher for part cutoff section
  if (properties.gotPartCatcher && partCutoff && currentSection.partCatcher) {
    engagePartCatcher(true);
  }

  // command stop for manual tool change, useful for quick change live tools
  if (insertToolCall && tool.manualToolChange) {
    onCommand(COMMAND_STOP);
    writeBlock("(" + "MANUAL TOOL CHANGE TO T" + toolFormat.format(tool.number * 100 + compensationOffset) + ")");
  }

  // Engage tailstock
  if (properties.useTailStock != "false") {
    if (!retracted && ((currentSection.useTailStock || forceTailStock) != machineState.tailstockIsActive)) {
      goHome();
      retracted = true;
    }
    engageTailStock(true);
  }

  // Check operation type with connected spindles
  if (machineState.spindlesAreAttached) {
    if (machineState.axialCenterDrilling || (getSpindle(PART) == SPINDLE_SUB) ||
      (getParameter("operation-strategy") == "turningFace") ||
      ((getSpindle(TOOL) == SPINDLE_LIVE) && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      error(localize("Illegal cutting operation programmed when spindles are synchronized."));
      return;
    }
  }

  // Output spindle codes
  if (newSpindle) {
    // select spindle if required
  }

  var forceRPMMode = false;
  if ((insertToolCall ||
    newSpindle ||
    isFirstSection() ||
    isSpindleSpeedDifferent()) &&
    (!machineState.stockTransferIsActive || forceSpindle)) {
    if (machineState.isTurningOperation) {
      if (spindleSpeed > properties.maximumSpindleSpeed) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
      }
    } else {
      if (spindleSpeed > 6000) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
      }
    }

    // Turn spindle on
    if (!tapping) {
      forceRPMMode = (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) && !machineState.spindlesAreAttached && !machineState.spindlesAreSynchronized;
      startSpindle(false, forceRPMMode, getFramePosition(currentSection.getInitialPosition()));
    }
  }

  // Turn off interference checking with secondary spindle
  if (getSpindle(PART) == SPINDLE_SUB) {
    writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(PART))));
  }

  // Live Spindle is active with synchronized C-axes
  // need to wait until after spindle speed is output to synchronize the C-axes
  if ((tempSpindle == SPINDLE_LIVE) && machineState.spindlesAreAttached) {
    if (!machineState.cAxesAreSynchronized) {
      writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", SPINDLE_SUB)), formatComment("INTERLOCK BYPASS"));
      clampChuck(getSecondarySpindle(), UNCLAMP);
      onDwell(1.0);
      writeBlock(cAxisEngageModal.format(getCode("ENABLE_C_AXIS", SPINDLE_MAIN)));
      writeBlock(gMotionModal.format(0), gFormat.format(28), "H" + abcFormat.format(0)); // unwind c-axis
      writeBlock(cAxisEngageModal.format(getCode("ENABLE_C_AXIS", SPINDLE_SUB)));
      writeBlock(gMotionModal.format(0), gFormat.format(28), "H" + abcFormat.format(0)); // unwind c-axis
      writeBlock(cAxisEngageModal.format(getCode("ENABLE_C_AXIS", SPINDLE_MAIN)));
      writeBlock(mFormat.format(getCode("CONNECT_C_AXES", SPINDLE_MAIN)), formatComment("SYNCHRONIZE C1 C2"));
      clampChuck(SPINDLE_SUB, CLAMP);
      onDwell(1.0);
    }
  }

  forceAny();
  gMotionModal.reset();

  if (currentSection.isMultiAxis()) {
    writeBlock(gMotionModal.format(0), aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z));
    previousABC = abc;
    forceWorkPlane();
    cancelTransformation();
  } else {
    if (machineState.isTurningOperation && gotBAxis && (activeTurret != 2) && !bAxisIsManual) {
      setSpindleOrientationTurning(insertToolCall);
    } else if (machineState.isTurningOperation) {
      if (gotBAxis && (activeTurret != 2)) {
        setSpindleOrientationMilling(abc);
      }
    } else if ((gotBAxis && (activeTurret != 2)) && !bAxisIsManual) {
      setWorkPlane(abc);
    } else if (!machineState.isTurningOperation && !machineState.axialCenterDrilling && !machineState.useXZCMode && !machineState.usePolarMode) {
      setWorkPlane(abc);
    }
  }
  forceAny();
  if (abc !== undefined) {
    cOutput.format(abc.z); // make C current - we do not want to output here
  }
  gMotionModal.reset();
  var initialPosition = getFramePosition(currentSection.getInitialPosition());

  if (insertToolCall || retracted || (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
    // gPlaneModal.reset();
    gMotionModal.reset();
    if (machineState.useXZCMode || machineState.usePolarMode) {
      // writeBlock(gPlaneModal.format(getG17Code()));
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      writeBlock(
        gMotionModal.format(0),
        xOutput.format(getModulus(initialPosition.x, initialPosition.y)),
        conditional(gotYAxis, yOutput.format(0)),
        conditional(machineState.useXZCMode, cOutput.format(getC(initialPosition.x, initialPosition.y)))
      );
    } else if ((gotBAxis && activeTurret != 2) && (abc.y != 0)) {
      writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z));
    } else {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
    }
  } else if ((machineState.useXZCMode || machineState.usePolarMode) && yAxisWasEnabled) {
    if (gotYAxis && yOutput.isEnabled()) {
      writeBlock(gMotionModal.format(0), yOutput.format(0));
    }
  }

  // enable SFM spindle speed
  if (forceRPMMode) {
    startSpindle(false, false);
  }

  if (machineState.usePolarMode) {
    setPolarMode(true); // enable polar interpolation mode
  }

  if (properties.useParametricFeed &&
    hasParameter("operation-strategy") &&
    (getParameter("operation-strategy") != "drill") && // legacy
    !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
      activeMovements &&
      (getCurrentSectionId() > 0) &&
      ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }

  previousSpindle = tempSpindle;
  activeSpindle = tempSpindle;

  if (false) { // DEBUG
    for (var key in machineState) {
      writeComment(key + " : " + machineState[key]);
    }
    writeComment("Machining direction = " + getMachiningDirection(currentSection));
    writeComment("Tapping = " + tapping);
    // writeln("(" + (getMachineConfigurationAsText(machineConfiguration)) + ")");
  }
}

/** Returns true if the toolpath fits within the machine XY limits for the given C orientation. */
function doesToolpathFitInXYRange(abc) {
  var c = 0;
  if (abc) {
    c = abc.z;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    c *= (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    c *= (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  var dx = new Vector(Math.cos(c), Math.sin(c), 0);
  var dy = new Vector(Math.cos(c + Math.PI / 2), Math.sin(c + Math.PI / 2), 0);

  if (currentSection.getGlobalRange) {
    var xRange = currentSection.getGlobalRange(dx);
    var yRange = currentSection.getGlobalRange(dy);

    if (false) { // DEBUG
      writeComment("toolpath X min: " + xFormat.format(xRange[0]) + ", " + "Limit " + xFormat.format(xAxisMinimum));
      writeComment("X-min within range: " + (xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum)));
      writeComment("toolpath Y min: " + spatialFormat.getResultingValue(yRange[0]) + ", " + "Limit " + yAxisMinimum);
      writeComment("Y-min within range: " + (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum));
      writeComment("toolpath Y max: " + (spatialFormat.getResultingValue(yRange[1]) + ", " + "Limit " + yAxisMaximum));
      writeComment("Y-max within range: " + (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum));
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
  var forward = section.workPlane.forward;
  if (isSameDirection(forward, new Vector(0, 0, 1))) {
    return MACHINING_DIRECTION_AXIAL;
  } else if (Vector.dot(forward, new Vector(0, 0, 1)) < 1e-7) {
    return MACHINING_DIRECTION_RADIAL;
  } else {
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
        if (gotPolarInterpolation && forcePolarMode) { // polar mode is requested by user
          machineState.usePolarMode = true;
        } else if (forceXZCMode) { // XZC mode is requested by user
          machineState.useXZCMode = true;
        } else { // see if toolpath fits in XY-range
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
        hasYMotion = false; // all other cycles don´t have Y-axis motion
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
    cOutput.enable();
    cOutput.reset();
    writeBlock(gMotionModal.format(0), cOutput.format(0)); // set C-axis to 0 to avoid G112 issues
    writeBlock(gPolarModal.format(getCode("POLAR_INTERPOLATION_ON", getSpindle(PART)))); // command for polar interpolation
    writeBlock(gPlaneModal.format(18));
    if (getSpindle(PART) == SPINDLE_SUB) {
      invertAxes(true, true);
    } else {
      yOutput = createVariable({ prefix: "C" }, yFormat);
      yOutput.enable(); // required for G12.1
      cOutput.disable();
    }
  } else {
    writeBlock(gPolarModal.format(getCode("POLAR_INTERPOLATION_OFF", getSpindle(PART))));
    yOutput = createVariable({ prefix: "Y" }, yFormat);
    if (!gotYAxis) {
      yOutput.disable();
    }
    cOutput.enable();
  }
}

function goHome() {
  var yAxis = "";
  if (gotYAxis) {
    yAxis = "V" + yFormat.format(0);
  }
  writeBlock(gMotionModal.format(0), gFormat.format(28), "U" + xFormat.format(0), yAxis);
  if (properties.useG28Zhome) {
    writeBlock(gMotionModal.format(0), gFormat.format(28), "W" + zFormat.format(0));
  } else {
    gMotionModal.reset();
    zOutput.reset();
    writeBlock(gMotionModal.format(0), zOutput.format(properties.zHomePosition), "T" + toolFormat.format(0));
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  writeBlock(gFormat.format(4), dwellFormat.format(seconds));
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
      var currentC = getCClosest(_x, _y, cOutput.getCurrent());
      var c = cOutput.format(currentC);
      var z = zOutput.format(_z);
      if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation mode cannot be changed at rapid traversal."));
        return;
      }
      writeBlock(gMotionModal.format(0), x, c, z);
      previousABC.setZ(currentC);
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
    var useG1 = ((((x ? 1 : 0) + (y ? 1 : 0) + (z ? 1 : 0)) > 1) || machineState.usePolarMode) && !isCannedCycle;
    var highFeed = machineState.usePolarMode ? toPreciseUnit(1500, MM) : getHighfeedrate(_x);
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      var ccLeft = ((getSpindle(PART) == SPINDLE_SUB) && properties.reverseAxes) ? 42 : 41;
      var ccRight = ((getSpindle(PART) == SPINDLE_SUB) && properties.reverseAxes) ? 41 : 42;
      if (useG1) {
        switch (radiusCompensation) {
          case RADIUS_COMPENSATION_LEFT:
            writeBlock(
              gMotionModal.format(1),
              gFormat.format(ccLeft),
              x, y, z, getFeed(highFeed)
            );
            break;
          case RADIUS_COMPENSATION_RIGHT:
            writeBlock(
              gMotionModal.format(1),
              gFormat.format(ccRight),
              x, y, z, getFeed(highFeed)
            );
            break;
          default:
            writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, getFeed(highFeed));
        }
      } else {
        switch (radiusCompensation) {
          case RADIUS_COMPENSATION_LEFT:
            writeBlock(
              gMotionModal.format(0),
              gFormat.format(ccLeft),
              x, y, z
            );
            break;
          case RADIUS_COMPENSATION_RIGHT:
            writeBlock(
              gMotionModal.format(0),
              gFormat.format(ccRight),
              x, y, z
            );
            break;
          default:
            writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
        }
      }
    } else {
      if (useG1) {
        // axes are not synchronized
        writeBlock(gMotionModal.format(1), x, y, z, getFeed(highFeed));
        resetFeed = false;
      } else {
        writeBlock(gMotionModal.format(0), x, y, z);
        // forceFeed();
      }
    }
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

function onLinear(_x, _y, _z, feed) {
  if (machineState.useXZCMode) {
    if (pendingRadiusCompensation >= 0) {
      error(subst(localize("Radius compensation is not supported for operation \"%1\". You have to use G112 mode for radius compensation."), getOperationComment()));
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
    // var endC = getCWithinRange(endXYZ.x, endXYZ.y, startC);
    var endC = getCClosest(endXYZ.x, endXYZ.y, startC);

    var currentXYZ = endXYZ; var currentX = endX; var currentZ = endZ; var currentC = endC;
    var centerXYZ = machineConfiguration.getAxisU().getOffset();

    var refined = true;
    var crossingRotary = false;
    forceOptimized = false; // tool tip is provided to DPM calculations
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
          // currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
          currentC = getCClosest(currentXYZ.x, currentXYZ.y, startC);
          if (Vector.diff(startXYZ, currentXYZ).length < 1e-5) { // back to start point, output error
            /*if (forceRewind) {
              break;
            } else*/ {
              warning(localize("Linear move cannot be mapped to rotary XZC motion."));
              break;
            }
          }
        }
      }

      // currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
      currentC = getCClosest(currentXYZ.x, currentXYZ.y, startC);
      /*if (forceRewind) {
        var rewindC = getCClosest(startXYZ.x, startXYZ.y, currentC);
        xOutput.reset(); // force X for repositioning
        rewindTable(startXYZ, currentZ, rewindC, feed, true);
        previousABC.setZ(rewindC);
      }*/
      var x = xOutput.format(currentX);
      var c = cOutput.format(currentC);
      var z = zOutput.format(currentZ);
      var actualFeed = getMultiaxisFeed(currentXYZ.x, currentXYZ.y, currentXYZ.z, 0, 0, currentC, feed);
      if (x || c || z) {
        writeBlock(gMotionModal.format(1), x, c, z, getFeed(actualFeed.frn));
      }
      setCurrentPosition(currentXYZ);
      previousABC.setZ(currentC);
      if (crossingRotary) {
        writeBlock(gMotionModal.format(1), cOutput.format(endC), getFeed(feed)); // rotate at X0 with endC
        previousABC.setZ(endC);
        forceFeed();
      }
      startX = currentX; startZ = currentZ; startC = crossingRotary ? endC : currentC; startXYZ = currentXYZ; // loop start point
      currentX = endX; currentZ = endZ; currentC = endC; currentXYZ = endXYZ; // loop end point
      crossingRotary = false;
    }
    forceOptimized = undefined;
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
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (machineState.isTurningOperation) {
        writeBlock(gPlaneModal.format(18));
      } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
        writeBlock(gPlaneModal.format(getG17Code()));
      } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
        writeBlock(gPlaneModal.format(19));
      } else {
        error(localize("Tool orientation is not supported for radius compensation."));
        return;
      }
      var ccLeft = ((getSpindle(PART) == SPINDLE_SUB) && properties.reverseAxes) ? 42 : 41;
      var ccRight = ((getSpindle(PART) == SPINDLE_SUB) && properties.reverseAxes) ? 41 : 42;
      switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(
            gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1),
            gFormat.format(ccLeft),
            x, y, z, f
          );
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(
            gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1),
            gFormat.format(ccRight),
            x, y, z, f
          );
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
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  if (true) {
    // axes are not synchronized
    var actualFeed = getMultiaxisFeed(_x, _y, _z, _a, _b, _c, highFeedrate);
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, getFeed(actualFeed.frn));
  } else {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
    forceFeed();
  }
  previousABC = new Vector(_a, _b, _c);
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
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);

  var actualFeed = getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed);
  var f = getFeed(actualFeed.frn);

  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
  previousABC = new Vector(_a, _b, _c);
}

// Start of multi-axis feedrate logic
/***** Be sure to add 'useInverseTime' to post properties if necessary. *****/
/***** 'inverseTimeOutput' should be defined if Inverse Time feedrates are supported. *****/
/***** 'previousABC' can be added throughout to maintain previous rotary positions. Required for Mill/Turn machines. *****/
/***** 'headOffset' should be defined when a head rotary axis is defined. *****/
/***** The feedrate mode must be included in motion block output (linear, circular, etc.) for Inverse Time feedrate support. *****/
var dpmBPW = 0.1; // ratio of rotary accuracy to linear accuracy for DPM calculations
var inverseTimeUnits = 1.0; // 1.0 = minutes, 60.0 = seconds
var maxInverseTime = 45000; // maximum value to output for Inverse Time feeds
var maxDPM = 99999; // maximum value to output for DPM feeds
var useInverseTimeFeed = false; // use DPM feeds
var previousDPMFeed = 0; // previously output DPM feed
var dpmFeedToler = 0.5; // tolerance to determine when the DPM feed has changed
var previousABC = new Vector(0, 0, 0); // previous ABC position if maintained in post, don't define if not used
var forceOptimized = undefined; // used to override optimized-for-angles points (XZC-mode)

/** Calculate the multi-axis feedrate number. */
function getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed) {
  var f = { frn: 0, fmode: 0 };
  if (feed <= 0) {
    error(localize("Feedrate is less than or equal to 0."));
    return f;
  }

  var length = getMoveLength(_x, _y, _z, _a, _b, _c);

  if (useInverseTimeFeed) { // inverse time
    f.frn = getInverseTime(length.tool, feed);
    f.fmode = 93;
    feedOutput.reset();
  } else { // degrees per minute
    f.frn = getFeedDPM(length, feed);
    f.fmode = 94;
  }
  return f;
}

/** Returns point optimization mode. */
function getOptimizedMode() {
  if (forceOptimized != undefined) {
    return forceOptimized;
  }
  // return (currentSection.getOptimizedTCPMode() != 0); // TAG:doesn't return correct value
  return true; // always return false for non-TCP based heads
}

/** Calculate the DPM feedrate number. */
function getFeedDPM(_moveLength, _feed) {
  if ((_feed == 0) || (_moveLength.tool < 0.0001) || (toDeg(_moveLength.abcLength) < 0.0005)) {
    previousDPMFeed = 0;
    return _feed;
  }
  var moveTime = _moveLength.tool / _feed;
  if (moveTime == 0) {
    previousDPMFeed = 0;
    return _feed;
  }

  var dpmFeed;
  var tcp = !getOptimizedMode() && (forceOptimized == undefined);   // set to false for rotary heads
  if (tcp) { // TCP mode is supported, output feed as FPM
    dpmFeed = _feed;
  } else if (true) { // standard DPM
    dpmFeed = Math.min(toDeg(_moveLength.abcLength) / moveTime, maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else if (false) { // combination FPM/DPM
    var length = Math.sqrt(Math.pow(_moveLength.xyzLength, 2.0) + Math.pow((toDeg(_moveLength.abcLength) * dpmBPW), 2.0));
    dpmFeed = Math.min((length / moveTime), maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else { // machine specific calculation
    dpmFeed = _feed;
  }
  previousDPMFeed = dpmFeed;
  return dpmFeed;
}

/** Calculate the Inverse time feedrate number. */
function getInverseTime(_length, _feed) {
  var inverseTime;
  if (_length < 1.e-6) { // tool doesn't move
    if (typeof maxInverseTime === "number") {
      inverseTime = maxInverseTime;
    } else {
      inverseTime = 999999;
    }
  } else {
    inverseTime = _feed / _length / inverseTimeUnits;
    if (typeof maxInverseTime === "number") {
      if (inverseTime > maxInverseTime) {
        inverseTime = maxInverseTime;
      }
    }
  }
  return inverseTime;
}

/** Calculate radius for each rotary axis. */
function getRotaryRadii(startTool, endTool, startABC, endABC) {
  var radii = new Vector(0, 0, 0);
  var startRadius;
  var endRadius;
  var axis = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
  for (var i = 0; i < 3; ++i) {
    if (axis[i].isEnabled()) {
      var startRadius = getRotaryRadius(axis[i], startTool, startABC);
      var endRadius = getRotaryRadius(axis[i], endTool, endABC);
      radii.setCoordinate(axis[i].getCoordinate(), Math.max(startRadius, endRadius));
    }
  }
  return radii;
}

/** Calculate the distance of the tool position to the center of a rotary axis. */
function getRotaryRadius(axis, toolPosition, abc) {
  if (!axis.isEnabled()) {
    return 0;
  }

  var direction = axis.getEffectiveAxis();
  var normal = direction.getNormalized();
  // calculate the rotary center based on head/table
  var center;
  var radius;
  if (axis.isHead()) {
    var pivot;
    if (typeof headOffset === "number") {
      pivot = headOffset;
    } else {
      pivot = tool.getBodyLength();
    }
    if (axis.getCoordinate() == machineConfiguration.getAxisU().getCoordinate()) { // rider
      center = Vector.sum(toolPosition, Vector.product(machineConfiguration.getDirection(abc), pivot));
      center = Vector.sum(center, axis.getOffset());
      radius = Vector.diff(toolPosition, center).length;
    } else { // carrier
      var angle = abc.getCoordinate(machineConfiguration.getAxisU().getCoordinate());
      radius = Math.abs(pivot * Math.sin(angle));
      radius += axis.getOffset().length;
    }
  } else {
    center = axis.getOffset();
    var d1 = toolPosition.x - center.x;
    var d2 = toolPosition.y - center.y;
    var d3 = toolPosition.z - center.z;
    var radius = Math.sqrt(
      Math.pow((d1 * normal.y) - (d2 * normal.x), 2.0) +
      Math.pow((d2 * normal.z) - (d3 * normal.y), 2.0) +
      Math.pow((d3 * normal.x) - (d1 * normal.z), 2.0)
    );
  }
  return radius;
}

/** Calculate the linear distance based on the rotation of a rotary axis. */
function getRadialDistance(radius, startABC, endABC) {
  // calculate length of radial move
  var delta = Math.abs(endABC - startABC);
  if (delta > Math.PI) {
    delta = 2 * Math.PI - delta;
  }
  var radialLength = (2 * Math.PI * radius) * (delta / (2 * Math.PI));
  return radialLength;
}

/** Calculate tooltip, XYZ, and rotary move lengths. */
function getMoveLength(_x, _y, _z, _a, _b, _c) {
  // get starting and ending positions
  var moveLength = {};
  var startTool;
  var endTool;
  var startXYZ;
  var endXYZ;
  var startABC;
  if (typeof previousABC !== "undefined") {
    startABC = new Vector(previousABC.x, previousABC.y, previousABC.z);
  } else {
    startABC = getCurrentDirection();
  }
  var endABC = new Vector(_a, _b, _c);

  if (!getOptimizedMode()) { // calculate XYZ from tool tip
    startTool = getCurrentPosition();
    endTool = new Vector(_x, _y, _z);
    startXYZ = startTool;
    endXYZ = endTool;

    // adjust points for tables
    if (!machineConfiguration.getTableABC(startABC).isZero() || !machineConfiguration.getTableABC(endABC).isZero()) {
      startXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).getTransposed().multiply(startXYZ);
      endXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).getTransposed().multiply(endXYZ);
    }

    // adjust points for heads
    if (machineConfiguration.getAxisU().isEnabled() && machineConfiguration.getAxisU().isHead()) {
      if (typeof getOptimizedHeads === "function") { // use post processor function to adjust heads
        startXYZ = getOptimizedHeads(startXYZ.x, startXYZ.y, startXYZ.z, startABC.x, startABC.y, startABC.z);
        endXYZ = getOptimizedHeads(endXYZ.x, endXYZ.y, endXYZ.z, endABC.x, endABC.y, endABC.z);
      } else { // guess at head adjustments
        var startDisplacement = machineConfiguration.getDirection(startABC);
        startDisplacement.multiply(headOffset);
        var endDisplacement = machineConfiguration.getDirection(endABC);
        endDisplacement.multiply(headOffset);
        startXYZ = Vector.sum(startTool, startDisplacement);
        endXYZ = Vector.sum(endTool, endDisplacement);
      }
    }
  } else { // calculate tool tip from XYZ, heads are always programmed in TCP mode, so not handled here
    startXYZ = getCurrentPosition();
    endXYZ = new Vector(_x, _y, _z);
    startTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).multiply(startXYZ);
    endTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).multiply(endXYZ);
  }

  // calculate axes movements
  moveLength.xyz = Vector.diff(endXYZ, startXYZ).abs;
  moveLength.xyzLength = moveLength.xyz.length;
  moveLength.abc = Vector.diff(endABC, startABC).abs;
  for (var i = 0; i < 3; ++i) {
    if (moveLength.abc.getCoordinate(i) > Math.PI) {
      moveLength.abc.setCoordinate(i, 2 * Math.PI - moveLength.abc.getCoordinate(i));
    }
  }
  moveLength.abcLength = moveLength.abc.length;

  // calculate radii
  moveLength.radius = getRotaryRadii(startTool, endTool, startABC, endABC);

  // calculate the radial portion of the tool tip movement
  var radialLength = Math.sqrt(
    Math.pow(getRadialDistance(moveLength.radius.x, startABC.x, endABC.x), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.y, startABC.y, endABC.y), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.z, startABC.z, endABC.z), 2.0)
  );

  // calculate the tool tip move length
  // tool tip distance is the move distance based on a combination of linear and rotary axes movement
  moveLength.tool = moveLength.xyzLength + radialLength;

  // debug
  if (false) {
    writeComment("DEBUG - tool   = " + moveLength.tool);
    writeComment("DEBUG - xyz    = " + moveLength.xyz);
    var temp = Vector.product(moveLength.abc, 180 / Math.PI);
    writeComment("DEBUG - abc    = " + temp);
    writeComment("DEBUG - radius = " + moveLength.radius);
  }
  return moveLength;
}
// End of multi-axis feedrate logic

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var directionCode;
  if (getSpindle(PART) == SPINDLE_SUB && properties.reverseAxes) {
    directionCode = clockwise ? 3 : 2;
  } else {
    directionCode = clockwise ? 2 : 3;
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
            previousABC.setZ(c);
            return;
          }
        }
        break;
      case PLANE_XY:
        var d2 = center.x * center.x + center.y * center.y;
        if (d2 < 1e-6) { // center is on rotary axis
          var c = getCClosest(x, y, cOutput.getCurrent(), !clockwise);
          var actualFeed = getMultiaxisFeed(x, y, z, 0, 0, c, feed);
          writeBlock(gMotionModal.format(1), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), getFeed(actualFeed.frn));
          previousABC.setZ(c);
          return;
        }
        break;
    }

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

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
        break;
      case PLANE_ZX:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
        break;
      case PLANE_YZ:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
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
        writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
        break;
      case PLANE_ZX:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
        break;
      case PLANE_YZ:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
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
        writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      case PLANE_ZX:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      case PLANE_YZ:
        if (machineState.usePolarMode) {
          linearize(tolerance);
          return;
        }
        writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      default:
        linearize(tolerance);
    }
  }
}

function onCycle() {
  if ((typeof isSubSpindleCycle == "function") && isSubSpindleCycle(cycleType)) {
    writeln("");
    if (hasParameter("operation-comment")) {
      var comment = getParameter("operation-comment");
      if (comment) {
        writeComment(comment);
      }
    }

    // Start of stock transfer operation(s)
    if (!machineState.stockTransferIsActive) {
      if (cycleType != "secondary-spindle-return") {
        moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", false);
        goHome();
      }
      onCommand(COMMAND_STOP_SPINDLE);
      onCommand(COMMAND_COOLANT_OFF);
      onCommand(COMMAND_OPTIONAL_STOP);
      forceUnlockMultiAxis();
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      if (cycle.stopSpindle) {
        writeBlock(gMotionModal.format(0), gFormat.format(28), "H" + abcFormat.format(0));
      }
      gFeedModeModal.reset();
      var feedMode;
      if (currentSection.feedMode == FEED_PER_REVOLUTION) {
        feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_REV", getSpindle(TOOL)));
      } else {
        feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL)));
      }
      gPlaneModal.reset();
      if (!properties.optimizeCaxisSelect) {
        cAxisEngageModal.reset();
      }
      writeBlock(feedMode, gPlaneModal.format(18), cAxisEngageModal.format(getCode("DISABLE_C_AXIS", getSpindle(PART))));
      writeBlock(mFormat.format(getCode("DISABLE_C_AXIS", getSecondarySpindle())));
    }

    switch (cycleType) {
      case "secondary-spindle-return":
        var secondaryPull = false;
        var secondaryHome = false;

        // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
        var feedDis = 0;
        var feedPosition = cycle.feedPosition;
        if (cycle.useMachineFrame == 1) {
          if (hasParameter("operation:feedPlaneHeight_direct")) { // Inventor
            feedDis = getParameter("operation:feedPlaneHeight_direct");
          } else if (hasParameter("operation:feedPlaneHeightDirect")) { // HSMWorks
            feedDis = getParameter("operation:feedPlaneHeightDirect");
          }
          feedPosition = feedDis;
        } else if (hasParameter("operation:feedPlaneHeight_offset")) { // Inventor
          feedDis = getParameter("operation:feedPlaneHeight_offset");
        } else if (hasParameter("operation:feedPlaneHeightOffset")) { // HSMWorks
          feedDis = getParameter("operation:feedPlaneHeightOffset");
        }
        // Transfer part to secondary spindle
        if (cycle.unclampMode != "keep-clamped") {
          secondaryPull = feedDis != 0;
          secondaryHome = true;
        } else {
          // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
          secondaryPull = feedDis != 0;
          secondaryHome = !secondaryPull;
        }

        writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSecondarySpindle())));
        if (secondaryPull) {
          clampChuck(getSpindle(PART), UNCLAMP);
          onDwell(cycle.dwell);
          moveSubSpindle(FEED, feedPosition, cycle.feedrate, cycle.useMachineFrame, "BAR PULL", true);
        }
        if (secondaryHome) {
          if (cycle.unclampMode == "unclamp-secondary") { // leave part in main spindle
            clampChuck(getSpindle(PART), CLAMP);
            onDwell(cycle.dwell);
            clampChuck(getSecondarySpindle(), UNCLAMP);
            onDwell(cycle.dwell);
          } else if (cycle.unclampMode == "unclamp-primary") {
            clampChuck(getSpindle(PART), UNCLAMP);
            onDwell(cycle.dwell);
          }
          moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
        } else {
          clampChuck(getSpindle(PART), CLAMP);
          onDwell(cycle.dwell);
          // writeBlock(mFormat.format(getCode("COOLANT_THROUGH_TOOL_OFF", getSecondarySpindle())));
          mInterferModal.reset();
          writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(PART))));
        }
        machineState.stockTransferIsActive = true;
        break;

      case "secondary-spindle-grab":
        if (currentSection.partCatcher) {
          engagePartCatcher(true);
        }
        writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSecondarySpindle())), formatComment("INTERLOCK BYPASS"));
        clampChuck(getSecondarySpindle(), UNCLAMP);
        onDwell(cycle.dwell);
        gSpindleModeModal.reset();

        if (cycle.stopSpindle) { // no spindle rotation
          lastSpindleSpeed = 0;
        } else { // spindle rotation
          var transferCodes = getSpindleTransferCodes(transferType);

          // Write out maximum spindle speed
          if (transferCodes.spindleMode == SPINDLE_CONSTANT_SURFACE_SPEED) {
            var maximumSpindleSpeed = (transferCodes.maximumSpindleSpeed > 0) ? Math.min(transferCodes.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
            writeBlock(gFormat.format(50), sOutput.format(maximumSpindleSpeed));
            sOutput.reset();
          }
          // write out spindle speed
          var _spindleSpeed;
          var spindleMode;
          if (transferCodes.spindleMode == SPINDLE_CONSTANT_SURFACE_SPEED) {
            _spindleSpeed = transferCodes.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
            spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON", getSpindle(PART));
          } else {
            _spindleSpeed = cycle.spindleSpeed;
            spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(PART));
          }
          var comment;
          if (transferType == TRANSFER_PHASE) {
            comment = "PHASE SYNCHRONIZATION";
          } else {
            comment = "SPEED SYNCHRONIZATION";
          }
          writeBlock(
            gSpindleModeModal.format(spindleMode),
            sOutput.format(_spindleSpeed),
            mFormat.format(transferCodes.direction),
            spOutput.format(getCode("SELECT_SPINDLE", getSpindle(PART))),
            formatComment(comment)
          );
          lastSpindleMode = transferCodes.spindleMode;
          lastSpindleSpeed = _spindleSpeed;
          lastSpindleDirection = transferCodes.spindleDirection;
        }

        // clean out chips
        if (airCleanChuck) {
          writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", SPINDLE_MAIN)), formatComment("CLEAN OUT CHIPS"));
          writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", SPINDLE_SUB)));
          onDwell(5.5);
          writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", SPINDLE_MAIN)));
          writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", SPINDLE_SUB)));
        }

        writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(PART))));
        gMotionModal.reset();
        moveSubSpindle(RAPID, cycle.feedPosition, 0, cycle.useMachineFrame, "", true);

        if (transferUseTorque) {
          writeBlock(mFormat.format(getCode("TORQUE_SKIP_ON", getSpindle(PART))), formatComment("TORQUE SKIP ON"));
          moveSubSpindle(TORQUE, cycle.chuckPosition, cycle.feedrate, cycle.useMachineFrame, "", true);
          writeBlock(mFormat.format(getCode("TORQUE_SKIP_OFF", getSpindle(PART))), formatComment("TORQUE SKIP OFF"));
        } else {
          moveSubSpindle(FEED, cycle.chuckPosition, cycle.feedrate, cycle.useMachineFrame, "", true);
        }
        clampChuck(getSecondarySpindle(), CLAMP);
        writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSpindle(PART))), formatComment("INTERLOCK BYPASS"));

        onDwell(cycle.dwell);
        machineState.stockTransferIsActive = true;
        break;
    }
  }

  if (cycleType == "stock-transfer") {
    warning(localize("Stock transfer is not supported. Required machine specific customization."));
    return;
  } else if (!properties.useCycles && tapping) {
    startSpindle(false, false);
  }
}

var saveShowSequenceNumbers = true;
var xyzFormat = createFormat({ decimals: (unit == MM ? 4 : 5), forceDecimal: true });
var pathBlockNumber = { start: 0, end: 0 };
var isCannedCycle = false;

function onCyclePath() {
  saveShowSequenceNumbers = showSequenceNumbers;
  isCannedCycle = true;
  // buffer all paths and stop feeds being output
  feedOutput.disable();
  showSequenceNumbers = false;
  redirectToBuffer();
  gMotionModal.reset();
  xOutput.reset();
  zOutput.reset();
}

function onCyclePathEnd() {
  showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
  feedOutput.enable();
  var cyclePath = String(getRedirectionBuffer()).split(EOL); // get cycle path from buffer
  closeRedirection();
  for (line in cyclePath) { // remove empty elements
    if (cyclePath[line] == "") {
      cyclePath.splice(line);
    }
  }

  var verticalPasses;
  if (cycle.profileRoughingCycle == 0) {
    verticalPasses = false;
  } else if (cycle.profileRoughingCycle == 1) {
    verticalPasses = true;
  } else {
    error(localize("Unsupported passes type."));
    return;
  }
  // output cycle data
  switch (cycleType) {
    case "turning-canned-rough":
      writeBlock(gFormat.format(verticalPasses ? 72 : 71),
        (verticalPasses ? "W" : "U") + xyzFormat.format(cycle.depthOfCut),
        "R" + xyzFormat.format(cycle.retractLength)
      );
      writeBlock(gFormat.format(verticalPasses ? 72 : 71),
        "P" + (getStartEndSequenceNumber(cyclePath, true)),
        "Q" + (getStartEndSequenceNumber(cyclePath, false)),
        "U" + xFormat.format(cycle.xStockToLeave),
        "W" + xyzFormat.format(cycle.zStockToLeave),
        getFeed(cycle.cutfeedrate)
      );
      break;
    default:
      error(localize("Unsupported turning canned cycle."));
  }

  for (var i = 0; i < cyclePath.length; ++i) {
    if (i == 0 || i == (cyclePath.length - 1)) { // write sequence number on first and last line of the cycle path
      showSequenceNumbers = true;
      if ((i == 0 && pathBlockNumber.start != sequenceNumber) || (i == (cyclePath.length - 1) && pathBlockNumber.end != sequenceNumber)) {
        error(localize("Mismatch of start/end block number in turning canned cycle."));
        return;
      }
    }
    writeBlock(cyclePath[i]); // output cycle path
    showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
    isCannedCycle = false;
  }
}

function getStartEndSequenceNumber(cyclePath, start) {
  if (start) {
    pathBlockNumber.start = sequenceNumber + conditional(saveShowSequenceNumbers, properties.sequenceNumberIncrement);
    return pathBlockNumber.start;
  } else {
    pathBlockNumber.end = sequenceNumber + properties.sequenceNumberIncrement + conditional(saveShowSequenceNumbers, (cyclePath.length - 1) * properties.sequenceNumberIncrement);
    return pathBlockNumber.end;
  }
}

function getCommonCycle(x, y, z, r, includeRcode) {

  // R-value is incremental position from current position
  var raptoS = "";
  if ((r !== undefined) && includeRcode) {
    raptoS = "R" + spatialFormat.format(r);
  }

  if (machineState.useXZCMode) {
    cOutput.reset();
    return [xOutput.format(getModulus(x, y)), cOutput.format(getCClosest(x, y, cOutput.getCurrent())),
    zOutput.format(z),
      raptoS];
  } else {
    return [xOutput.format(x), yOutput.format(y),
    zOutput.format(z),
      raptoS];
  }
}

function writeCycleClearance(plane, clearance) {
  var currentPosition = getCurrentPosition();
  if (true) {
    onCycleEnd();
    switch (plane) {
      case 17:
        writeBlock(gMotionModal.format(0), zOutput.format(clearance));
        break;
      case 18:
        writeBlock(gMotionModal.format(0), yOutput.format(clearance));
        break;
      case 19:
        writeBlock(gMotionModal.format(0), xOutput.format(clearance));
        break;
      default:
        error(localize("Unsupported drilling orientation."));
        return;
    }
  }
}

var threadStart;
var threadEnd;
function moveToThreadStart(x, y, z) {
  var cuttingAngle = 0;
  if (hasParameter("operation:infeedAngle")) {
    cuttingAngle = getParameter("operation:infeedAngle");
  }
  if (cuttingAngle != 0) {
    var zz;
    if (isFirstCyclePoint()) {
      threadStart = getCurrentPosition();
      threadEnd = new Vector(x, y, z);
    } else {
      var zz = threadStart.z - (Math.abs(threadEnd.x - x) * Math.tan(toRad(cuttingAngle)));
      writeBlock(gMotionModal.format(0), zOutput.format(zz));
      threadStart.setZ(zz);
      threadEnd = new Vector(x, y, z);
    }
  }
}

function onCyclePoint(x, y, z) {

  if (!properties.useCycles || currentSection.isMultiAxis()) {
    expandCyclePoint(x, y, z);
    return;
  }

  var plane = gPlaneModal.getCurrent();
  var localZOutput = zOutput;
  var cycleAxis = currentSection.workPlane.forward;
  var found = false;
  if ((gotBAxis && (activeTurret != 2)) && !bAxisIsManual) {
    if (!getTCP(previousABC)) {
      plane = 19; // use G19 for B-axis with 368 mode
      localZoutput = xOutput;
      found = true;
    }
  }
  if (!found) {
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1)) ||
      isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
      plane = 17; // XY plane
      localZOutput = zOutput;
    } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
      plane = 19; // YZ plane
      localZOutput = xOutput;
    } else if ((gotBAxis && (activeTurret != 2)) && !bAxisIsManual) {
      plane = 19;  // use G19 for B-axis when outside major plane
      localZoutput = xOutput;
    } else if (gotBAxis && (activeTurret != 2)) { // manual B-axis
      if (isSameDirection(machineConfiguration.getSpindleAxis(), new Vector(0, 0, 1)) ||
        isSameDirection(machineConfiguration.getSpindleAxis(), new Vector(0, 0, -1))) {
        plane = 17; // XY plane
        localZOutput = zOutput;
      } else if (Vector.dot(machineConfiguration.getSpindleAxis(), new Vector(0, 0, 1)) < 1e-7) {
        plane = 19; // YZ plane
        localZOutput = xOutput;
      } else {
        if (tapping) {
          error(localize("Tapping cycles cannot be expanded."));
          return;
        }
        expandCyclePoint(x, y, z);
        return;
      }
    } else {
      if (tapping) {
        error(localize("Tapping cycles cannot be expanded."));
        return;
      }
      expandCyclePoint(x, y, z);
      return;
    }
  }

  switch (cycleType) {
    case "thread-turning":
      if (properties.useSimpleThread ||
        (hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0)) ||
        (hasParameter("operation:infeedMode") && (getParameter("operation:infeedMode") != "constant"))) {
        var r = -cycle.incrementalX; // positive if taper goes down - delta radius
        moveToThreadStart(x, y, z);
        xOutput.reset();
        zOutput.reset();
        writeBlock(
          gMotionModal.format(92),
          xOutput.format(x),
          yOutput.format(y),
          zOutput.format(z),
          conditional(zFormat.isSignificant(r), g92ROutput.format(r)),
          pitchOutput.format(cycle.pitch)
        );
      } else {
        if (isLastCyclePoint()) {
          // thread height and depth of cut
          var threadHeight = getParameter("operation:threadDepth");
          var firstDepthOfCut = threadHeight / getParameter("operation:numberOfStepdowns");

          // first G76 block
          var repeatPass = hasParameter("operation:nullPass") ? getParameter("operation:nullPass") : 0;
          var chamferWidth = 10; // Pullout-width is 1*thread-lead in 1/10's;
          var materialAllowance = 0; // Material allowance for finishing pass
          var cuttingAngle = 60; // Angle is not stored with tool. toDeg(tool.getTaperAngle());
          if (hasParameter("operation:infeedAngle")) {
            cuttingAngle = getParameter("operation:infeedAngle");
          }
          var pcode = repeatPass * 10000 + chamferWidth * 100 + cuttingAngle;
          gCycleModal.reset();
          writeBlock(
            gCycleModal.format(76),
            threadP1Output.format(pcode),
            threadQOutput.format(firstDepthOfCut),
            threadROutput.format(materialAllowance)
          );

          // second G76 block
          var r = -cycle.incrementalX; // positive if taper goes down - delta radius
          gCycleModal.reset();
          writeBlock(
            gCycleModal.format(76),
            xOutput.format(x),
            zOutput.format(z),
            conditional(zFormat.isSignificant(r), threadROutput.format(r)),
            threadP2Output.format(threadHeight),
            threadQOutput.format(firstDepthOfCut),
            pitchOutput.format(cycle.pitch)
          );
        }
      }
      forceFeed();
      return;
  }

  // clamp the C-axis if necessary
  // the C-axis is automatically unclamped by the controllers during cycles
  var lockCode = "";
  if (!machineState.axialCenterDrilling && !machineState.isTurningOperation) {
    lockCode = mFormat.format(getCode("LOCK_MULTI_AXIS", getSpindle(PART)));
  }

  var rapto = 0;
  if (isFirstCyclePoint()) { // first cycle point
    rapto = (getSpindle(PART) == SPINDLE_SUB) ? cycle.clearance - cycle.retract : cycle.retract - cycle.clearance;

    var F = (gFeedModeModal.getCurrent() == 99 ? cycle.feedrate / spindleSpeed : cycle.feedrate);
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
      case "drilling":
        writeCycleClearance(plane, cycle.clearance);
        localZOutput.reset();
        writeBlock(
          gCycleModal.format(plane == 19 ? 87 : 83),
          getCommonCycle(x, y, z, rapto, true),
          conditional(P > 0, pOutput.format(P)),
          feedOutput.format(F),
          lockCode
        );
        break;
      case "chip-breaking":
        if (cycle.accumulatedDepth < cycle.depth) {
          expandCyclePoint(x, y, z);
        } else {
          writeCycleClearance(plane, cycle.clearance);
          localZOutput.reset();
          writeBlock(
            gCycleModal.format(plane == 19 ? 87 : 83),
            getCommonCycle(x, y, z, rapto, true),
            conditional(cycle.incrementalDepth > 0, peckOutput.format(cycle.incrementalDepth)),
            conditional(P > 0, pOutput.format(P)),
            feedOutput.format(F),
            lockCode
          );
        }
        break;
      case "deep-drilling":
        writeCycleClearance(plane, cycle.clearance);
        localZOutput.reset();
        writeBlock(
          gCycleModal.format(plane == 19 ? 87 : 83),
          getCommonCycle(x, y, z, rapto, true),
          conditional(cycle.incrementalDepth > 0, peckOutput.format(cycle.incrementalDepth)),
          conditional(P > 0, pOutput.format(P)),
          feedOutput.format(F),
          lockCode
        );
        break;
      case "tapping":
      case "right-tapping":
      case "left-tapping":
        writeCycleClearance(plane, cycle.clearance);
        localZOutput.reset();
        if (!F) {
          F = tool.getTappingFeedrate();
        }
        startSpindle(true, false);
        reverseTap = tool.type == TOOL_TAP_LEFT_HAND;
        if (reverseTap) {
          writeBlock(mFormat.format(176));
        }
        writeBlock(
          gCycleModal.format(plane == 19 ? 88 : 84),
          getCommonCycle(x, y, z, rapto, true),
          conditional(P > 0, pOutput.format(P)),
          pitchOutput.format(F),
          lockCode
        );
        break;
      case "tapping-with-chip-breaking":
        writeCycleClearance(plane, cycle.clearance);
        localZOutput.reset();
        if (!F) {
          F = tool.getTappingFeedrate();
        }
        startSpindle(true, false);
        reverseTap = tool.type == TOOL_TAP_LEFT_HAND;
        if (reverseTap) {
          writeBlock(mFormat.format(176));
        }
        writeBlock(
          gCycleModal.format(plane == 19 ? 88 : 84),
          getCommonCycle(x, y, z, rapto, true),
          conditional(cycle.incrementalDepth > 0, peckOutput.format(cycle.incrementalDepth)),
          conditional(P > 0, pOutput.format(P)),
          pitchOutput.format(F),
          lockCode
        );
        break;
      case "boring":
        writeCycleClearance(plane, cycle.clearance);
        localZOutput.reset();
        writeBlock(
          gCycleModal.format(plane == 19 ? 89 : 85),
          getCommonCycle(x, y, z, rapto, true),
          conditional(P > 0, pOutput.format(P)),
          feedOutput.format(F),
          lockCode
        );
        break;
      default:
        expandCyclePoint(x, y, z);
    }
  } else { // position to subsequent cycle points
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      var step = 0;
      if (cycleType == "chip-breaking" || cycleType == "deep-drilling") {
        step = cycle.incrementalDepth;
      }
      writeBlock(getCommonCycle(x, y, z, rapto, false), conditional(step > 0, peckOutput.format(step)), lockCode);
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded && !machineState.stockTransferIsActive) {
    writeBlock(gCycleModal.format(80));
    gMotionModal.reset();
  }
}

function onPassThrough(text) {
  writeBlock(text);
}

function onParameter(name, value) {
  var invalid = false;
  switch (name) {
    case "action":
      if (String(value).toUpperCase() == "PARTEJECT") {
        ejectRoutine = true;
      } else if (String(value).toUpperCase() == "USEXZCMODE") {
        forceXZCMode = true;
        forcePolarMode = false;
      } else if (String(value).toUpperCase() == "USEPOLARMODE") {
        forcePolarMode = true;
        forceXZCMode = false;
      } else {
        var sText1 = String(value);
        var sText2 = new Array();
        sText2 = sText1.split(":");
        if (sText2.length != 2) {
          error(localize("Invalid action command: ") + value);
          return;
        }
        if (sText2[0].toUpperCase() == "TRANSFERTYPE") {
          transferType = parseToggle(sText2[1], "PHASE", "SPEED");
          if (transferType == undefined) {
            error(localize("TransferType must be Phase or Speed"));
            return;
          }
        } else if (sText2[0].toUpperCase() == "TRANSFERUSETORQUE") {
          transferUseTorque = parseToggle(sText2[1], "YES", "NO");
          if (transferUseTorque == undefined) {
            invalid = true;
          }
        } else if (sText2[0].toUpperCase() == "USETAILSTOCK") {
          forceTailStock = parseToggle(sText2[1], "YES", "NO");
          if (forceTailStock == undefined) {
            invalid = true;
          }
        } else if (sText2[0].toUpperCase() == "SYNCSPINDLESTART") {
          syncStartMethod = parseToggle(sText2[1], "ERROR", "UNCLAMP", "SPEED");
          if (syncStartMethod == undefined) {
            invalid = true;
          }
        } else {
          invalid = true;
        }
      }
  }
  if (invalid) {
    error(localize("Invalid action parameter: ") + sText2[0] + ":" + sText2[1]);
    return;
  }
}

function parseToggle() {
  var stat = undefined;
  for (i = 1; i < arguments.length; i++) {
    if (String(arguments[0]).toUpperCase() == String(arguments[i]).toUpperCase()) {
      if (String(arguments[i]).toUpperCase() == "YES") {
        stat = true;
      } else if (String(arguments[i]).toUpperCase() == "NO") {
        stat = false;
      } else {
        stat = i - 1;
        break;
      }
    }
  }
  return stat;
}

var currentCoolantMode = COOLANT_OFF;

function setCoolant(coolant) {
  if (coolant == currentCoolantMode) {
    return; // coolant is already active
  }

  var m = undefined;
  if (coolant == COOLANT_OFF) {
    if (currentCoolantMode == COOLANT_THROUGH_TOOL) {
      m = getCode("COOLANT_THROUGH_TOOL_OFF", getSpindle(TOOL));
    } else if (currentCoolantMode == COOLANT_AIR) {
      m = getCode("COOLANT_AIR_OFF", getSpindle(PART));
    } else if (currentCoolantMode == COOLANT_MIST) {
      m = getCode("COOLANT_MIST_OFF", getSpindle(PART));
    } else {
      m = getCode("COOLANT_OFF", getSpindle(PART));
    }
    writeBlock(mFormat.format(m));
    currentCoolantMode = COOLANT_OFF;
    return;
  }

  if ((currentCoolantMode != COOLANT_OFF) && (coolant != currentCoolantMode)) {
    setCoolant(COOLANT_OFF);
  }

  switch (coolant) {
    case COOLANT_FLOOD:
      m = 8;
      break;
    case COOLANT_THROUGH_TOOL:
      m = getCode("COOLANT_THROUGH_TOOL_ON", getSpindle(TOOL));
      break;
    case COOLANT_AIR:
      m = getCode("COOLANT_AIR_ON", getSpindle(PART));
      break;
    case COOLANT_MIST:
      m = getCode("COOLANT_MIST_ON", getSpindle(PART));
      break;
    case COOLANT_SUCTION:
      m = getCode("COOLANT_SUCTION_ON", getSpindle(PART));
      break;
    default:
      warning(localize("Coolant not supported."));
      if (currentCoolantMode == COOLANT_OFF) {
        return;
      }
      coolant = COOLANT_OFF;
      m = getCode("COOLANT_OFF", getSpindle(PART));
  }

  writeBlock(mFormat.format(m));
  currentCoolantMode = coolant;
}

function isSpindleSpeedDifferent() {
  var areDifferent = false;
  if (isFirstSection()) {
    areDifferent = true;
  }
  if (lastSpindleDirection != tool.clockwise) {
    areDifferent = true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    var _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if ((lastSpindleMode != SPINDLE_CONSTANT_SURFACE_SPEED) ||
      rpmFormat.areDifferent(lastSpindleSpeed, _spindleSpeed)) {
      areDifferent = true;
    }
  } else {
    if ((lastSpindleMode != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
      rpmFormat.areDifferent(lastSpindleSpeed, spindleSpeed)) {
      areDifferent = true;
    }
  }
  return areDifferent;
}

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) {
    writeBlock(sOutput.format(spindleSpeed));
  }
}

function startSpindle(tappingMode, forceRPMMode, initialPosition) {
  var spindleDir;
  var _spindleSpeed;
  var spindleMode;
  gSpindleModeModal.reset();

  if ((getSpindle(PART) == SPINDLE_SUB) && !gotSecondarySpindle) {
    error(localize("Secondary spindle is not available."));
    return;
  }

  // spindle block cannot be output when spindles are synchronized
  var clampSpindles = false;
  if (machineState.spindlesAreSynchronized || machineState.spindlesAreAttached) {
    // Turning
    if (machineState.isTurningOperation) {
      if (syncStartMethod == SYNC_ERROR) {
        if (isSpindleSpeedDifferent()) {
          error(localize("A spindle start block cannot be output while the spindles are synchronized."));
          return;
        } else {
          return;
        }
      } else if (syncStartMethod == SYNC_UNCLAMP) {
        writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSecondarySpindle())));
        clampChuck(getSecondarySpindle(), UNCLAMP);
        onDwell(1.0);
        clampSpindles = true;
        machineState.spindlesAreAttached = true; // must set so synchronized spindle code is used
      }
      // Live tool
    } else {
      if (machineState.cAxesAreSynchronized) {
        writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSecondarySpindle())));
        clampChuck(getSecondarySpindle(), UNCLAMP);
        onDwell(1.0);
        clampSpindles = true;
        writeBlock(mFormat.format(getCode("DISCONNECT_C_AXES", SPINDLE_MAIN)), formatComment("DISCONNECT C1 C2"));
      }
    }
  }

  if (tappingMode) {
    spindleDir = mFormat.format(getCode("RIGID_TAPPING", getSpindle(TOOL)));
  } else if (machineState.spindlesAreAttached && getSpindle(TOOL) != SPINDLE_LIVE) {
    var method = ((machineState.spindlesAreSynchronized || machineState.spindlesAreAttached) && (syncStartMethod == SYNC_SPEED)) ? TRANSFER_SPEED : transferType;
    var code = (method == TRANSFER_PHASE) ? getCode("SPINDLE_SYNCHRONIZATION_PHASE", getSpindle(PART)) : getCode("SPINDLE_SYNCHRONIZATION_SPEED", getSpindle(PART));
    spindleDir = mFormat.format(tool.clockwise ? code : (code + 1));
  } else {
    spindleDir = mFormat.format(tool.clockwise ? getCode("START_SPINDLE_CW", getSpindle(TOOL)) : getCode("START_SPINDLE_CCW", getSpindle(TOOL)));
  }

  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if (forceRPMMode) { // RPM mode is forced until move to initial position
      if (xFormat.getResultingValue(initialPosition.x) == 0) {
        _spindleSpeed = maximumSpindleSpeed;
      } else {
        _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
      }
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(TOOL));
    } else {
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON", getSpindle(TOOL));
    }
  } else {
    _spindleSpeed = spindleSpeed;
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(TOOL));
  }
  writeBlock(
    gSpindleModeModal.format(spindleMode),
    sOutput.format(_spindleSpeed),
    spindleDir,
    spOutput.format(getCode("SELECT_SPINDLE", getSpindle(TOOL)))
  );
  // wait for spindle here if required

  // clamp secondary chuck if necessary
  if (clampSpindles) {
    if (machineState.liveToolIsActive) {
      writeBlock(mFormat.format(getCode("CONNECT_C_AXES", SPINDLE_MAIN)), formatComment("SYNCHRONIZE C1 C2"));
    }
    clampChuck(getSecondarySpindle(), CLAMP);
    onDwell(1.0);
  }

  lastSpindleMode = tool.getSpindleMode();
  lastSpindleSpeed = _spindleSpeed;
  lastSpindleDirection = tool.clockwise;
}

function stopSpindle() {
  if (machineState.cAxesAreSynchronized) {
    writeBlock(mFormat.format(getCode("DISCONNECT_C_AXES", SPINDLE_MAIN)), formatComment("DISCONNECT C1 C2"));
  }
  if (machineState.spindlesAreSynchronized) {
    writeBlock(
      mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_OFF", activeSpindle)),
      spOutput.format(getCode("SELECT_SPINDLE", activeSpindle))
    );
    sOutput.reset();
  } else {
    writeBlock(
      mFormat.format(getCode("STOP_SPINDLE", activeSpindle)),
      spOutput.format(getCode("SELECT_SPINDLE", activeSpindle))
    );
  }
  lastSpindleSpeed = 0;
  lastSpindleDirection = undefined;
  sOutput.reset();
}

/** Positions the sub spindle */
function moveSubSpindle(_method, _position, _feed, _useMachineFrame, _comment, _error) {
  if (!gotSecondarySpindle) {
    return;
  }
  if (machineState.spindlesAreAttached) {
    if (_error) {
      error(localize("An attempt was made to position the sub-spindle with both chucks clamped."));
    }
    return;
  }
  switch (_method) {
    case HOME:
      if ((properties.useTailStock == "false") || !machineState.tailstockIsActive) { // don't retract B-axis if used as a tailstock
        writeBlock(
          gMotionModal.format(0),
          gFormat.format(28),
          gFormat.format(53),
          subOutput.format(0),
          conditional(_comment, formatComment(_comment))
        );
      }
      break;
    case RAPID:
      writeBlock(
        gMotionModal.format(0),
        conditional(_useMachineFrame, gFormat.format(53)),
        subOutput.format(_position),
        conditional(_comment, formatComment(_comment))
      );
      break;
    case FEED:
      writeBlock(
        conditional(_useMachineFrame, gFormat.format(53)),
        gMotionModal.format(1),
        subOutput.format(_position),
        getFeed(_feed),
        conditional(_comment, formatComment(_comment))
      );
      break;
    case TORQUE:
      writeBlock(
        gFormat.format(31),
        pOutput.format(99),
        conditional(_useMachineFrame == 1, gFormat.format(53)),
        subOutput.format(_position),
        getFeed(_feed),
        conditional(_comment, formatComment(_comment))
      );
      break;
  }
}

function clampChuck(_spindle, _clamp) {
  if (_spindle == SPINDLE_MAIN) {
    if (_clamp != machineState.mainChuckIsClamped) {
      writeBlock(mFormat.format(getCode(_clamp ? "CLAMP_CHUCK" : "UNCLAMP_CHUCK", _spindle)),
        formatComment(_clamp ? "CLAMP MAIN CHUCK" : "UNCLAMP MAIN CHUCK"));
      machineState.mainChuckIsClamped = _clamp;
    }
  } else {
    if (_clamp != machineState.subChuckIsClamped) {
      writeBlock(mFormat.format(getCode(_clamp ? "CLAMP_CHUCK" : "UNCLAMP_CHUCK", _spindle)),
        formatComment(_clamp ? "CLAMP SUB CHUCK" : "UNCLAMP SUB CHUCK"));
      machineState.subChuckIsClamped = _clamp;
    }
  }
  machineState.spindlesAreAttached = machineState.mainChuckIsClamped && machineState.subChuckIsClamped;
}

function onCommand(command) {
  switch (command) {
    case COMMAND_COOLANT_OFF:
      setCoolant(COOLANT_OFF);
      break;
    case COMMAND_COOLANT_ON:
      setCoolant(COOLANT_FLOOD);
      break;
    case COMMAND_LOCK_MULTI_AXIS:
      writeBlock(cAxisBrakeModal.format(getCode("LOCK_MULTI_AXIS", getSpindle(PART))));
      break;
    case COMMAND_UNLOCK_MULTI_AXIS:
      writeBlock(cAxisBrakeModal.format(getCode("UNLOCK_MULTI_AXIS", getSpindle(PART))));
      break;
    case COMMAND_START_CHIP_TRANSPORT:
      writeBlock(mFormat.format(24));
      break;
    case COMMAND_STOP_CHIP_TRANSPORT:
      writeBlock(mFormat.format(25));
      break;
    case COMMAND_OPEN_DOOR:
      if (gotDoorControl) {
        writeBlock(mFormat.format(52)); // optional
      }
      break;
    case COMMAND_CLOSE_DOOR:
      if (gotDoorControl) {
        writeBlock(mFormat.format(53)); // optional
      }
      break;
    case COMMAND_BREAK_CONTROL:
      break;
    case COMMAND_TOOL_MEASURE:
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
    case COMMAND_STOP_SPINDLE:
      stopSpindle();
      break;
    case COMMAND_ORIENTATE_SPINDLE:
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(mFormat.format(getCode("ORIENT_SPINDLE", getSpindle(PART))));
      } else {
        error(localize("Spindle orientation is not supported for live tooling."));
        return;
      }
      break;
    case COMMAND_SPINDLE_CLOCKWISE:
      writeBlock(mFormat.format(getCode("START_SPINDLE_CW", getSpindle(TOOL))),
        spOutput.format(getCode("SELECT_SPINDLE", getSpindle(TOOL)))
      );
      break;
    case COMMAND_SPINDLE_COUNTERCLOCKWISE:
      writeBlock(mFormat.format(getCode("START_SPINDLE_CCW", getSpindle(TOOL))),
        spOutput.format(getCode("SELECT_SPINDLE", getSpindle(TOOL)))
      );
      break;
    // case COMMAND_CLAMP: // add support for clamping
    // case COMMAND_UNCLAMP: // add support for clamping
    default:
      onUnsupportedCommand(command);
  }
}

/** Get synchronization/transfer code based on part cutoff spindle direction. */
function getSpindleTransferCodes(_transferType) {
  var transferCodes = { direction: 0, spindleMode: 0, surfaceSpeed: 0, maximumSpindleSpeed: 0 };
  if (_transferType == TRANSFER_PHASE) {
    transferCodes.direction = getCode("SPINDLE_SYNCHRONIZATION_PHASE", getSecondarySpindle());
  } else {
    transferCodes.direction = getCode("SPINDLE_SYNCHRONIZATION_SPEED", getSecondarySpindle());
  }
  transferCodes.spindleDirection = true; // clockwise
  if (isLastSection()) {
    return transferCodes;
  }
  var numberOfSections = getNumberOfSections();
  for (var i = getNextSection().getId(); i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getParameter("operation-strategy") == "turningSecondarySpindleReturn") {
      continue;
    } else if (section.getType() != TYPE_TURNING || section.spindle != SPINDLE_MAIN) {
      break;
    } else if (section.getType() == TYPE_TURNING) {
      var tool = section.getTool();
      if (!tool.clockwise) {
        transferCodes.direction += 1;
      }
      transferCodes.spindleMode = tool.getSpindleMode();
      transferCodes.surfaceSpeed = tool.surfaceSpeed;
      transferCodes.maximumSpindleSpeed = tool.maximumSpindleSpeed;
      transferCodes.spindleDirection = tool.clockwise;
      break;
    }
  }
  return transferCodes;
}

function getG17Code() {
  return machineState.usePolarMode ? 18 : 17;
}

function ejectPart() {
  if (machineState.spindlesAreAttached) {
    error(localize("Cannot eject part when spindles are connected."));
  }
  if (machineState.subChuckIsClamped) {
    spindle = getSecondarySpindle();
  } else {
    spindle = getSpindle(PART);
  }
  writeln("");
  if (properties.sequenceNumberToolOnly) {
    writeCommentSeqno(localize("PART EJECT"));
  } else {
    writeComment(localize("PART EJECT"));
  }
  gMotionModal.reset();
  moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
  goHome(); // Position all axes to home position
  writeBlock(mFormat.format(getCode("UNLOCK_MULTI_AXIS", spindle)));
  if (!properties.optimizeCaxisSelect) {
    cAxisEngageModal.reset();
  }
  writeBlock(
    gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", spindle)),
    gFormat.format(53 + currentWorkOffset),
    gPlaneModal.format(getG17Code()),
    cAxisEngageModal.format(getCode("DISABLE_C_AXIS", spindle))
  );
  setCoolant(COOLANT_THROUGH_TOOL);
  gSpindleModeModal.reset();
  writeBlock(
    gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", spindle)),
    sOutput.format(50),
    mFormat.format(getCode("START_SPINDLE_CW", spindle)),
    spOutput.format(getCode("SELECT_SPINDLE", spindle))
  );
  writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", spindle)));
  if (properties.gotPartCatcher) {
    writeBlock(mFormat.format(getCode("PART_CATCHER_ON", spindle)));
  }
  clampChuck(spindle, UNCLAMP);
  onDwell(1.5);
  if (properties.autoEject != "flush") {
    writeBlock(mFormat.format(getCode("CYCLE_PART_EJECTOR", spindle)));
    onDwell(0.5);
  }

  // clean out chips
  if (airCleanChuck) {
    writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", spindle)));
    onDwell(2.5);
    writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", spindle)));
  }
  writeBlock(mFormat.format(getCode("STOP_SPINDLE", spindle)), spOutput.format(getCode("SELECT_SPINDLE", spindle)));
  setCoolant(COOLANT_OFF);
  if (properties.gotPartCatcher) {
    onDwell(2); // allow coolant to drain
    writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", spindle)));
    onDwell(1.1);
  }
  writeComment(localize("END OF PART EJECT"));
  writeln("");
}

function engagePartCatcher(engage) {
  if (properties.gotPartCatcher) {
    if (engage) { // engage part catcher
      writeBlock(mFormat.format(getCode("PART_CATCHER_ON", true)), formatComment(localize("PART CATCHER ON")));
    } else { // disengage part catcher
      onCommand(COMMAND_COOLANT_OFF);
      writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", true)), formatComment(localize("PART CATCHER OFF")));
    }
  }
}

function engageTailStock(engage) {
  var _engage = engage;
  if (engage && (currentSection.tailstock || forceTailStock)) {
    if (machineState.axialCenterDrilling || (getSpindle(PART) == SPINDLE_SUB) ||
      (getParameter("operation-strategy") == "turningFace") ||
      ((getSpindle(TOOL) == SPINDLE_LIVE) && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      warning(localize("Tail stock is not supported for secondary spindle or Z-axis milling."));
      _engage = false;
    }
  } else if (!currentSection.tailstock && !forceTailStock) {
    _engage = false;
  }

  if (_engage) {
    if (!machineState.tailstockIsActive) {
      machineState.tailstockIsActive = true;
      if (properties.useTailStock == "true") {
        writeBlock(tailStockModal.format(getCode("TAILSTOCK_ON", SPINDLE_MAIN)));
      } else if (properties.useTailStock == "subSpindle" || properties.useTailStock == "noTorque") {
        if (getSpindle(PART) == SPINDLE_SUB) {
          error(localize("Only the sub spindle can be used as a live center tail stock."));
        }
        var rapidPosition = getGlobalParameter("stock-upper-z") + toPreciseUnit(0.25, IN);
        var feedPosition = getGlobalParameter("part-upper-z") - toPreciseUnit(0.25, IN);
        writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(PART))));
        gMotionModal.reset();
        moveSubSpindle(RAPID, rapidPosition, 0, false, "", true);
        // writeBlock(mFormat.format(getCode("TORQUE_SKIP_ON", getSpindle(PART))), formatComment("TORQUE SKIP ON"));
        writeBlock(gFormat.format(getCode("TAILSTOCK_CONTROL_ON", SPINDLE_MAIN)), subOutput.format(-100), formatComment("ENGAGE LIVE CENTER"));
        if (properties.useTailStock == "noTorque") {
          writeBlock(gFormat.format(getCode("TAILSTOCK_CONTROL_OFF", SPINDLE_MAIN)), formatComment("CANCEL TORQUE CONTROL"));
        }
        // writeBlock(mFormat.format(getCode("TORQUE_SKIP_OFF", getSpindle(PART))), formatComment("TORQUE SKIP OFF"));
      }
    }
  } else {
    if (machineState.tailstockIsActive) {
      machineState.tailstockIsActive = false;
      if (properties.useTailStock == "true") {
        writeBlock(tailStockModal.format(getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
      } else if (properties.useTailStock == "subSpindle") {
        writeBlock(gFormat.format(getCode("TAILSTOCK_CONTROL_OFF", SPINDLE_MAIN)), formatComment("CANCEL TORQUE CONTROL"));
        moveSubSpindle(HOME, rapidPosition, 0, true, "SUB SPINDLE RETURN", true);
      }
    }
  }
}

function onSectionEnd() {

  if (machineState.usePolarMode) {
    setPolarMode(false); // disable polar interpolation mode
  }

  // cancel SFM mode to preserve spindle speed
  if ((tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) &&
    !machineState.spindlesAreAttached && !machineState.spindlesAreSynchronized &&
    (currentSection.getParameter("operation-strategy") != "turningSecondarySpindleReturn")) {
    startSpindle(false, true, getFramePosition(currentSection.getFinalPosition()));
  }

  if (properties.gotPartCatcher && partCutoff && currentSection.partCatcher) {
    engagePartCatcher(false);
  }
  if (properties.cutoffConfirmation && partCutoff) {
    writeBlock(gFormat.format(350), formatComment("CONFIRM CUTOFF"));
    onDwell(0.5);
  }
  if (partCutoff) {
    machineState.spindlesAreAttached = false;
  }

  /*
  // Handled in start of onSection
  if (!isLastSection()) {
    if ((getLiveToolingMode(getNextSection()) < 0) && !currentSection.isPatterned() && (getLiveToolingMode(currentSection) >= 0)) {
      writeBlock(cAxisEngageModal.format(getCode("DISABLE_C_AXIS", getSpindle(PART))));
    }
  }
*/

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
    (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  if (getSpindle(TOOL) == SPINDLE_SUB) {
    invertAxes(false, false);
  }

  /*
  // Handled in onSection
  if ((currentSection.getType() == TYPE_MILLING) &&
      (!hasNextSection() || (hasNextSection() && (getNextSection().getType() != TYPE_MILLING)))) {
    // exit milling mode
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      // +Z
    } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
      // -Z
    } else {
      onCommand(COMMAND_STOP_SPINDLE);
    }
  }
*/

  forceXZCMode = false;
  forcePolarMode = false;
  partCutoff = false;
  forceAny();
}

function onClose() {

  var liveTool = getSpindle(TOOL) == SPINDLE_LIVE;
  optionalSection = false;
  onCommand(COMMAND_STOP_SPINDLE);
  setCoolant(COOLANT_OFF);

  // Cancel the reverse spindle code used in tapping
  if (reverseTap) {
    writeBlock(mFormat.format(177));
    reverseTap = false;
  }

  writeln("");

  if (properties.gotChipConveyor) {
    onCommand(COMMAND_STOP_CHIP_TRANSPORT);
  }

  // Move to home position
  goHome();

  if (machineState.tailstockIsActive) {
    engageTailStock(false);
  } else {
    gMotionModal.reset();
    moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", false);
  }

  cancelWorkPlane();

  if (!properties.optimizeCaxisSelect) {
    cAxisEngageModal.reset();
  }
  if (liveTool) {
    writeBlock(cAxisEngageModal.format(getCode("ENABLE_C_AXIS", getSpindle(PART))));
    writeBlock(gFormat.format(28), "H" + abcFormat.format(0)); // unwind
  }
  writeBlock(cAxisEngageModal.format(getCode("DISABLE_C_AXIS", getSpindle(PART))));

  // Automatically eject part
  if (ejectRoutine) {
    ejectPart();
  }

  writeBlock(gFormat.format(54), mFormat.format(80));

  writeln("");
  onImpliedCommand(COMMAND_END);
  if (gotSecondarySpindle) {
    writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_ON", getSpindle(PART))));
  }
  if (properties.looping) {
    writeBlock(mFormat.format(54), formatComment(localize("Increment part counter"))); //increment part counter
    writeBlock(mFormat.format(99));
  } else {
    writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
  }
  writeln("%");
}
