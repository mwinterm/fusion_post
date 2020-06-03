/**
  Copyright (C) 2012-2018 by Autodesk, Inc.
  All rights reserved.

  ProtoTRAK Lathe post processor configuration.

  $Revision: 42068 c23618952b3943eff31d9ccdd392217babcac996 $
  $Date: 2020-06-03 20:25:09 $
  
  FORKID {77299B79-7AA7-4B21-83A6-D6CD59182D2F}
*/

description = "ProtoTRAK Turning";
vendor = "Southwestern Industries";
vendorUrl = "http://www.southwesternindustries.com";
legal = "Copyright (C) 2012-2018 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 40783;

longDescription = "Generic turning post for ProtoTRAK. Use Turret 0 for Positional Turret, Turret 101 for QCTP on X- Post, Turret 102 for QCTP on X+ Post, Turret 103 for Gang Tooling on X- Post, Turret 104 for Gang Tooling on X+ Tool Post.";

extension = "cam";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = 1 << PLANE_ZX;



// user-defined properties
properties = {
  writeMachine: true, // write machine
  writeTools: true, // writes the tools
  writeVersion: true, // include version info
  // preloadTool: false, // preloads next tool on tool change if any
  showSequenceNumbers: true, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 1, // increment for sequence numbers
  optionalStop: true, // optional stop
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: false, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  reverseArcDirection: false, // some controls require G02/G03 to be swapped
  maximumSpindleSpeed: 100 * 60, // specifies the maximum spindle speed
  // useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: false, // specifies that operation notes should be output.
  useSimpleThread: true // outputs a G92 threading cycle, false outputs a G137 (standard) threading cycle
};

// user-defined property definitions
propertyDefinitions = {
  writeMachine: { title: "Write machine", description: "Output the machine settings in the header of the code.", group: 0, type: "boolean" },
  writeTools: { title: "Write tool list", description: "Output a tool list in the header of the code.", group: 0, type: "boolean" },
  writeVersion: { title: "Write version", description: "Write the version number in the header of the code.", group: 0, type: "boolean" },
  //preloadTool: {title:"Preload tool", description:"Preloads the next tool at a tool change (if any).", type:"boolean"},
  showSequenceNumbers: { title: "Use sequence numbers", description: "Use sequence numbers for each block of outputted code.", group: 1, type: "boolean" },
  sequenceNumberStart: { title: "Start sequence number", description: "The number at which to start the sequence numbers.", group: 1, type: "integer" },
  sequenceNumberIncrement: { title: "Sequence number increment", description: "The amount by which the sequence number is incremented by in each block.", group: 1, type: "integer" },
  optionalStop: { title: "Optional stop", description: "Outputs optional stop code during when necessary in the code.", type: "boolean" },
  separateWordsWithSpace: { title: "Separate words with space", description: "Adds spaces between words if 'yes' is selected.", type: "boolean" },
  useRadius: { title: "Radius arcs", description: "If yes is selected, arcs are outputted using radius values rather than IJK.", type: "boolean" },
  reverseArcDirection: { title: "Reverse G02/G03", description: "If yes is selected, reverses the directional codes of Arcs (G02 = CCW, G03 = CW).", type: "boolean" },
  maximumSpindleSpeed: { title: "Max spindle speed", description: "Defines the maximum spindle speed allowed by your machines.", type: "integer", range: [0, 999999999] },
  showNotes: { title: "Show notes", description: "Writes operation notes as comments in the outputted code.", type: "boolean" },
  useSimpleThread: { title: "Use simple threading cycle", description: "Enable to output G92 simple threading cycle, disable to output G130 standard threading cycle.", type: "boolean" }
};

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({ prefix: "G", width: 2, zeropad: true, decimals: 1 });
var mFormat = createFormat({ prefix: "M", width: 2, zeropad: true, decimals: 1 });

var spatialFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var xFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 2 }); // diameter mode
var yFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var zFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var rFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true }); // radius
var feedFormat = createFormat({ decimals: (unit == MM ? 4 : 5), forceDecimal: true });
var pitchFormat = createFormat({ decimals: 6, forceDecimal: true });
var toolFormat = createFormat({ decimals: 0, width: 2, zeropad: true });
var rpmFormat = createFormat({ decimals: 0 });
var secFormat = createFormat({ decimals: 3, forceDecimal: true }); // seconds - range 0.001-99999.999
var milliFormat = createFormat({ decimals: 0 }); // milliseconds // range 1-9999
var taperFormat = createFormat({ decimals: 1, scale: DEG });
var threadRadFormat = createFormat({ decimals: (unit == MM ? 3 : 4), suffix: "A", forceDecimal: true });
var threadDiaFormat = createFormat({ decimals: (unit == MM ? 3 : 4), suffix: "A", forceDecimal: true, scale: 2 });
var threadPFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true });
var threadNPFormat = createFormat({ decimals: 0, width: 2, zeropad: true });
var threadSIFormat = createFormat({ decimals: 0 });
var threadAFormat = createFormat({ decimals: 3, forceDecimal: true });

var xOutput = createVariable({ prefix: "X" }, xFormat);
var yOutput = createVariable({ prefix: "Y" }, yFormat);
var zOutput = createVariable({ prefix: "Z" }, zFormat);
var feedOutput = createVariable({ prefix: "F" }, feedFormat);
var pitchOutput = createVariable({ prefix: "F", force: true }, pitchFormat);
var sOutput = createVariable({ prefix: "S", force: true }, rpmFormat);
var threadXBOutput = createVariable({ prefix: "XB", force: true }, threadDiaFormat);
var threadXEOutput = createVariable({ prefix: "XE", force: true }, threadDiaFormat);
var threadXMOutput = createVariable({ prefix: "XM", force: true }, threadDiaFormat);
var threadZBOutput = createVariable({ prefix: "ZB", force: true }, threadRadFormat);
var threadZEOutput = createVariable({ prefix: "ZE", force: true }, threadRadFormat);
var threadPOutput = createVariable({ prefix: "PI", force: true }, threadPFormat);
var threadNPOutput = createVariable({ prefix: "NP", force: true }, threadNPFormat);
var threadSPOutput = createVariable({ prefix: "SP", force: true }, threadNPFormat);
var threadSIOutput = createVariable({ prefix: "SI", force: true }, threadSIFormat);
var threadAOutput = createVariable({ prefix: "A", force: true }, threadAFormat);
var threadSTOutput = createVariable({ prefix: "ST", force: true }, threadNPFormat);

// circular output
var kOutput = createReferenceVariable({ prefix: "K" }, spatialFormat);
var iOutput = createReferenceVariable({ prefix: "I" }, spatialFormat); // no scaling

var g92ROutput = createVariable({ prefix: "R" }, zFormat); // no scaling

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({ onchange: function () { gMotionModal.reset(); } }, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91 // only for B and C mode
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G98-99 / G94-95
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99

// fixed settings
var firstFeedParameter = 500;
var gotSecondarySpindle = true;
var gotTailStock = false;

var WARNING_WORK_OFFSET = 0;

var QCTP = 0;
var TURRET = 1;
var GANG = 2;

var FRONT = -1;
var REAR = 1;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var toolingData;
var previousToolingData;

function getCode(code) {
  switch (code) {
    // case "PART_CATCHER_ON":
    // return mFormat.format(SPECIFY YOUR CODE HERE);
    // case "PART_CATCHER_OFF":
    // return mFormat.format(SPECIFY YOUR CODE HERE);
    // case "TAILSTOCK_ON":
    // return mFormat.format(SPECIFY YOUR CODE HERE);
    // case "TAILSTOCK_OFF":
    // return mFormat.format(SPECIFY YOUR CODE HERE);
    // case "ENGAGE_C_AXIS":
    // machineState.cAxisIsEngaged = true;
    // return cAxisEngageModal.format(UNSUPPORTED);
    // case "DISENGAGE_C_AXIS":
    // machineState.cAxisIsEngaged = false;
    // return cAxisEngageModal.format(UNSUPPORTED);
    // case "POLAR_INTERPOLATION_ON":
    // return gPolarModal.format(UNSUPPORTED);
    // case "POLAR_INTERPOLATION_OFF":
    // return gPolarModal.format(UNSUPPORTED);
    // case "STOP_LIVE_TOOL":
    // machineState.liveToolIsActive = false;
    // return mFormat.format(UNSUPPORTED);
    // case "STOP_MAIN_SPINDLE":
    // machineState.mainSpindleIsActive = false;
    // return mFormat.format(UNSUPPORTED);
    // case "STOP_SUB_SPINDLE":
    // machineState.subSpindleIsActive = false;
    // return mFormat.format(UNSUPPORTED);
    // case "START_LIVE_TOOL_CW":
    // machineState.liveToolIsActive = true;
    // return mFormat.format(UNSUPPORTED);
    // case "START_LIVE_TOOL_CCW":
    // machineState.liveToolIsActive = true;
    // return mFormat.format(UNSUPPORTED);
    case "START_MAIN_SPINDLE_CW":
      // machineState.mainSpindleIsActive = true;
      return mFormat.format(3);
    case "START_MAIN_SPINDLE_CCW":
      // machineState.mainSpindleIsActive = true;
      return mFormat.format(4);
    // case "START_SUB_SPINDLE_CW":
    // machineState.subSpindleIsActive = true;
    // return mFormat.format(UNSUPPORTED);
    // case "START_SUB_SPINDLE_CCW":
    // machineState.subSpindleIsActive = true;
    // return mFormat.format(UNSUPPORTED);
    // case "MAIN_SPINDLE_BRAKE_ON":
    // machineState.mainSpindleBrakeIsActive = true;
    // return cAxisBrakeModal.format(UNSUPPORTED);
    // case "MAIN_SPINDLE_BRAKE_OFF":
    // machineState.mainSpindleBrakeIsActive = false;
    // return cAxisBrakeModal.format(UNSUPPORTED);
    // case "SUB_SPINDLE_BRAKE_ON":
    // machineState.subSpindleBrakeIsActive = true;
    // return cAxisBrakeModal.format(UNSUPPORTED);
    // case "SUB_SPINDLE_BRAKE_OFF":
    // machineState.subSpindleBrakeIsActive = false;
    // return cAxisBrakeModal.format(UNSUPPORTED);
    case "FEED_MODE_UNIT_REV":
      return gFeedModeModal.format(99);
    case "FEED_MODE_UNIT_MIN":
      return gFeedModeModal.format(98);
    case "CONSTANT_SURFACE_SPEED_ON":
      return gSpindleModeModal.format(96);
    case "CONSTANT_SURFACE_SPEED_OFF":
      return gSpindleModeModal.format(97);
    // case "MAINSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(UNSUPPORTED);
    // case "MAINSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(UNSUPPORTED);
    // case "SUBSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(UNSUPPORTED);
    // case "SUBSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(UNSUPPORTED);
    // case "CLAMP_PRIMARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
    // case "UNCLAMP_PRIMARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
    // case "CLAMP_SECONDARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
    // case "UNCLAMP_SECONDARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
    // case "SPINDLE_SYNCHRONIZATION_ON":
    // machineState.spindleSynchronizationIsActive = true;
    // return gSynchronizedSpindleModal.format(UNSUPPORTED);
    // case "SPINDLE_SYNCHRONIZATION_OFF":
    // machineState.spindleSynchronizationIsActive = false;
    // return gSynchronizedSpindleModal.format(UNSUPPORTED);
    // case "START_CHIP_TRANSPORT":
    // return mFormat.format(UNSUPPORTED);
    // case "STOP_CHIP_TRANSPORT":
    // return mFormat.format(UNSUPPORTED);
    // case "OPEN_DOOR":
    // return mFormat.format(UNSUPPORTED);
    // case "CLOSE_DOOR":
    // return mFormat.format(UNSUPPORTED);
    case "COOLANT_FLOOD_ON":
      return mFormat.format(8);
    case "COOLANT_MIST_ON":
      return mFormat.format(7);
    // case "COOLANT_FLOOD_OFF":
    // return mFormat.format(UNSUPPORTED);
    // case "COOLANT_AIR_ON":
    // return mFormat.format(UNSUPPORTED);
    // case "COOLANT_AIR_OFF":
    // return mFormat.format(UNSUPPORTED);
    // case "COOLANT_THROUGH_TOOL_ON":
    // return mFormat.format(UNSUPPORTED);
    // case "COOLANT_THROUGH_TOOL_OFF":
    // return mFormat.format(UNSUPPORTED);
    case "COOLANT_OFF":
      return mFormat.format(9);
    default:
      error(localize("Command " + code + " is not defined."));
      return 0;
  }
}

/**
  Writes the specified block.
*/
function writeBlock() {
  if (properties.showSequenceNumbers) {
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
  return "(" + filterText(String(text).toUpperCase(), permittedCommentChars).replace(/[\(\)]/g, "") + ")";
}

/**
  Defines a machine.
*/
function defineMachine() {
  machineConfiguration.setVendor(vendor);
  machineConfiguration.setModel("ProtoTrak");
  machineConfiguration.setDescription("Manual Tool Change Lathe");
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  yOutput.disable();

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
    if (programComment) {
      writeComment(programComment);
    }
  } else {
    error(localize("Program name has not been specified."));
    return;
  }


  //write program generation date and time
  let current_datetime = new Date();
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
    writeComment(localize("--- POST ---"));
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate().replace(/:/g, "-"));
    }
    writeln("");
  }

  // dump machine configuration
  defineMachine();
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
    writeln("");
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  gPlaneModal.format(18); // no output, just set G18 as active plane
  writeBlock(gFeedModeModal.format(98), gFormat.format(40));

  switch (unit) {
    case IN:
      writeBlock(gUnitModal.format(20));
      break;
    case MM:
      writeBlock(gUnitModal.format(21));
      break;
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

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, and F on next output. */
function forceAny() {
  forceXYZ();
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

function getSpindle() {
  if (getNumberOfSections() == 0) {
    return SPINDLE_PRIMARY;
  }
  if (getCurrentSectionId() < 0) {
    return getSection(getNumberOfSections() - 1).spindle == 0;
  }
  if (currentSection.getType() == TYPE_TURNING) {
    return currentSection.spindle;
  } else {
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      return SPINDLE_PRIMARY;
    } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
      if (!gotSecondarySpindle) {
        error(localize("Secondary spindle is not available."));
      }
      return SPINDLE_SECONDARY;
    } else {
      return SPINDLE_PRIMARY;
    }
  }
}

function ToolingData(_tool) {
  switch (_tool.turret) {
    // Positional Turret
    case 0:
      this.tooling = TURRET;
      this.toolPost = REAR;
      break;
    // QCTP X-
    case 101:
      this.tooling = QCTP;
      this.toolPost = FRONT;
      break;
    // QCTP X+
    case 102:
      this.tooling = QCTP;
      this.toolPost = REAR;
      break;
    // Gang Tooling X-
    case 103:
      this.tooling = GANG;
      this.toolPost = FRONT;
      break;
    // Gang Tooling X+
    case 104:
      this.tooling = GANG;
      this.toolPost = REAR;
      break;
    default:
      error(localize("Turret number must be 0 (main turret), 101 (QCTP X-), 102 (QCTP X+, 103 (gang tooling X-), or 104 (gang tooling X+)."));
      break;
  }
  this.number = _tool.number;
  this.comment = _tool.comment;
  this.toolLength = _tool.bodyLength;
  // HSMWorks returns 0 in tool.bodyLength
  if ((tool.bodyLength == 0) && hasParameter("operation:tool_bodyLength")) {
    this.toolLength = getParameter("operation:tool_bodyLength");
  }
}

function onSection() {
  if (currentSection.getType() != TYPE_TURNING) {
    if (!hasParameter("operation-strategy") || (getParameter("operation-strategy") != "drill")) {
      if (currentSection.getType() == TYPE_MILLING) {
        error(localize("Milling toolpath is not supported."));
      } else {
        error(localize("Non-turning toolpath is not supported."));
      }
      return;
    }
  }

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();

  var turning = (currentSection.getType() == TYPE_TURNING);

  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  var retracted = false; // specifies that the tool has been retracted to the safe plane
  var newSpindle = isFirstSection() ||
    (getPreviousSection().spindle != currentSection.spindle);
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes

  // determine which tooling holder is used
  if (!isFirstSection()) {
    previousToolingData = toolingData;
  }
  toolingData = new ToolingData(tool);
  toolingData.operationComment = "";
  if (hasParameter("operation-comment")) {
    toolingData.operationComment = getParameter("operation-comment");
  }
  toolingData.toolChange = insertToolCall;
  if (isFirstSection()) {
    previousToolingData = toolingData;
  }

  // turning using front tool post
  if (toolingData.toolPost == FRONT) {
    xFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: -2 });
    xOutput = createVariable({ prefix: "X" }, xFormat);
    iFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: -1 }); // radius mode
    iOutput = createReferenceVariable({ prefix: "I" }, iFormat);

    // turning using rear tool post
  } else {
    xFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 2 });
    xOutput = createVariable({ prefix: "X" }, xFormat);
    iFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: true, scale: 1 }); // radius mode
    iOutput = createReferenceVariable({ prefix: "I" }, iFormat);
  }

  if (insertToolCall || newSpindle || newWorkOffset) {
    // retract to safe plane
    // retracted = true;
    if (!isFirstSection() && insertToolCall) {
      onCommand(COMMAND_COOLANT_OFF);
    }
    // writeBlock(gFormat.format(28), "U" + xFormat.format(0)); // retract
    forceXYZ();
  }

  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

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

  if (insertToolCall) {
    // retracted = true;
    // onCommand(COMMAND_COOLANT_OFF);

    if (!isFirstSection() && properties.optionalStop) {
      onCommand(COMMAND_OPTIONAL_STOP);
    }

    if (tool.number > 99) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if ((toolingData.tooling == QCTP) || tool.getManualToolChange()) {
      var comment = formatComment(localize("CHANGE TO T") + tool.number + " " + localize("ON") + " " +
        localize((toolingData.toolPost == REAR) ? "REAR TOOL POST" : "FRONT TOOL POST"));
      writeBlock(mFormat.format(0), comment);
    }

    writeBlock("T" + toolFormat.format(tool.number), mFormat.format(6));
    if (tool.comment) {
      writeComment(tool.comment);
    }

    /*
        if (properties.preloadTool) {
          var nextTool = getNextTool(tool.number);
          if (nextTool) {
            var compensationOffset = nextTool.isTurningTool() ? nextTool.compensationOffset : nextTool.lengthOffset;
            if (compensationOffset > 99) {
              error(localize("Compensation offset is out of range."));
              return;
            }
            writeBlock("T" + toolFormat.format(nextTool.number * 100 + compensationOffset));
          } else {
            // preload first tool
            var section = getSection(0);
            var firstTool = section.getTool().number;
            if (tool.number != firstTool.number) {
              var compensationOffset = firstTool.isTurningTool() ? firstTool.compensationOffset : firstTool.lengthOffset;
              if (compensationOffset > 99) {
                error(localize("Compensation offset is out of range."));
                return;
              }
              writeBlock("T" + toolFormat.format(firstTool.number * 100 + compensationOffset));
            }
          }
        }
    */
  }

  /*
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
        var p = workOffset - 6; // 1->...
        if (p > 300) {
          error(localize("Work offset out of range."));
          return;
        } else {
          if (workOffset != currentWorkOffset) {
            writeBlock(gFormat.format(54.1), "P" + p); // G54.1P
            currentWorkOffset = workOffset;
          }
        }
      } else {
        if (workOffset != currentWorkOffset) {
          writeBlock(gFormat.format(53 + workOffset)); // G54->G59
          currentWorkOffset = workOffset;
        }
      }
    }
  */

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  forceAny();
  gMotionModal.reset();

  gFeedModeModal.reset();
  if (currentSection.feedMode == FEED_PER_REVOLUTION) {
    writeBlock(getCode("FEED_MODE_UNIT_REV"));
  } else {
    writeBlock(getCode("FEED_MODE_UNIT_MIN"));
  }

  if (gotTailStock) {
    writeBlock(currentSection.tailstock ? getCode("TAILSTOCK_ON") : getCode("TAILSTOCK_OFF"));
  }
  // writeBlock(mFormat.format(clampPrimaryChuck ? x : x));
  // writeBlock(mFormat.format(clampSecondaryChuck ? x : x));

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  startSpindle(false, true, initialPosition);

  setRotation(currentSection.workPlane);

  /*
    if (currentSection.partCatcher) {
      engagePartCatcher(true);
    }
  */
  if (!retracted) {
    // TAG: need to retract along X or Z
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    }
  }

  if (insertToolCall || (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
    gMotionModal.reset();
    writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z));
    gMotionModal.reset();
  }

  // enable SFM spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, false);
  }

  /*
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
  */
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  milliseconds = clamp(1, seconds * 1000, 99999999);
  writeBlock(/*gFeedModeModal.format(94),*/ gFormat.format(4), "P" + milliFormat.format(milliseconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(0), gFormat.format(41), x, y, z);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(0), gFormat.format(42), x, y, z);
          break;
        default:
          writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
      }
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
    }
    forceFeed();
  }
}

var resetFeed = false;

function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, f);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, f);
          break;
        default:
          writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

/** Adjust final point to lie exactly on circle. */
function CircularData(_plane, _center, _end) {
  // use Output variables, since last point could have been adjusted if previous move was circular
  var start = new Vector(xOutput.getCurrent(), yOutput.getCurrent(), zOutput.getCurrent());
  var saveStart = new Vector(start.x, start.y, start.z);
  var center = _center;
  var end = _end;
  switch (_plane) {
    case PLANE_XY:
      start.setZ(center.z);
      end.setZ(center.z);
      break;
    case PLANE_ZX:
      start.setY(center.y);
      end.setY(center.y);
      break;
    case PLANE_YZ:
      start.setX(center.x);
      end.setX(center.x);
      break;
    default:
      this.center = new Vector(center.x, center.y, center.z);
      this.start = new Vector(start.x, start.y, start.z);
      this.end = new Vector(_end.x, _end.y, _end.z);
      this.offset = Vector.diff(center, start);
      this.radius = this.offset.length;
      break;
  }
  this.start = new Vector(
    spatialFormat.getResultingValue(start.x),
    spatialFormat.getResultingValue(start.y),
    spatialFormat.getResultingValue(start.z)
  );
  temp = Vector.diff(center, start);
  this.offset = new Vector(
    spatialFormat.getResultingValue(temp.x),
    spatialFormat.getResultingValue(temp.y),
    spatialFormat.getResultingValue(temp.z)
  );
  this.center = Vector.sum(this.start, this.offset);
  this.radius = this.offset.length;

  temp = Vector.diff(end, center).normalized;
  this.end = new Vector(
    spatialFormat.getResultingValue(this.center.x + temp.x * radius),
    spatialFormat.getResultingValue(this.center.y + temp.y * radius),
    spatialFormat.getResultingValue(this.center.z + temp.z * radius)
  );

  switch (_plane) {
    case PLANE_XY:
      this.start.setZ(saveStart.z);
      this.end.setZ(_end.z);
      this.offset.setZ(0);
      break;
    case PLANE_ZX:
      this.start.setY(saveStart.y);
      this.end.setY(_end.y);
      this.offset.setY(0);
      break;
    case PLANE_YZ:
      this.start.setX(saveStart.x);
      this.end.setX(_end.x);
      this.offset.setX(0);
      break;
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  if (getCircularPlane() != PLANE_ZX) {
    linearize(tolerance);
    return;
  }

  var circle = new CircularData(getCircularPlane(), new Vector(cx, cy, cz), new Vector(x, y, z));

  var start = getCurrentPosition();
  var reversed = (properties.reverseArcDirection && toolingData.toolPost == REAR) ||
    (!properties.reverseArcDirection && toolingData.toolPost == FRONT);
  var direction = reversed ? (clockwise ? 3 : 2) : (clockwise ? 2 : 3);

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(
          gPlaneModal.format(17), gMotionModal.format(direction),
          iOutput.format(circle.offset.x, 0), jOutput.format(circle.offset.y, 0), feedOutput.format(feed)
        );
        break;
      case PLANE_ZX:
        writeBlock(
          gPlaneModal.format(18), gMotionModal.format(direction),
          iOutput.format(circle.offset.x, 0), kOutput.format(circle.offset.z, 0), feedOutput.format(feed)
        );
        break;
      case PLANE_YZ:
        writeBlock(
          gPlaneModal.format(19), gMotionModal.format(direction),
          jOutput.format(circle.offset.y, 0), kOutput.format(circle.offset.z, 0), feedOutput.format(feed)
        );
        break;
      default:
        linearize(tolerance);
    }
  } else if (!properties.useRadius) {
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(
          gPlaneModal.format(17), gMotionModal.format(direction),
          xOutput.format(circle.end.x), yOutput.format(circle.end.y), zOutput.format(circle.end.z),
          iOutput.format(circle.offset.x, 0), jOutput.format(circle.offset.y, 0), getFeed(feed)
        );
        break;
      case PLANE_ZX:
        writeBlock(
          gPlaneModal.format(18), gMotionModal.format(direction),
          xOutput.format(circle.end.x), yOutput.format(circle.end.y), zOutput.format(circle.end.z),
          iOutput.format(circle.offset.x, 0), kOutput.format(circle.offset.z, 0), getFeed(feed)
        );
        break;
      case PLANE_YZ:
        writeBlock(
          gPlaneModal.format(19), gMotionModal.format(direction),
          xOutput.format(circle.end.x), yOutput.format(circle.end.y), zOutput.format(circle.end.z),
          jOutput.format(circle.offset.y, 0), kOutput.format(circle.offset.z, 0), getFeed(feed)
        );
        break;
      default:
        linearize(tolerance);
    }
  } else { // use radius mode
    var r = circle.radius;
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gPlaneModal.format(17), gMotionModal.format(direction), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      case PLANE_ZX:
        writeBlock(gPlaneModal.format(18), gMotionModal.format(direction), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      case PLANE_YZ:
        writeBlock(gPlaneModal.format(19), gMotionModal.format(direction), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
        break;
      default:
        linearize(tolerance);
    }
  }
}

var localCycle;

function onCycle() {
}

/** Calculate threading cycle parameters, should be called on first pass. */
function ThreadingCycle(x, y, z) {
  var inverted = (toolingData.toolPost == REAR) ? 1 : -1;
  this.external = getParameter("operation:turningMode") == "outer";
  this.depth = getParameter("operation:threadDepth");
  this.springPass = getParameter("operation:nullPass");
  this.passes = getParameter("operation:numberOfStepdowns");
  this.pitch = cycle.pitch;
  this.infeedAngle = getParameter("operation:infeedAngle");
  this.threadStarts = getParameter("operation:doMultipleThreads") == 0 ? 1 : getParameter("operation:numberOfThreads");
  this.peck = this.depth / getParameter("operation:numberOfStepdowns");
  this.end = new Vector(x + (this.external ? this.peck : -this.peck), y, z);
  this.start = new Vector(this.end.x - (cycle.incrementalX * inverted), y, z - cycle.incrementalZ);
  this.bottom = this.start.x - (this.external ? this.depth : -this.depth);
}

function getCommonCycle(x, y, z, r) {
  forceXYZ(); // force xyz on first drill hole of any cycle
  return [xOutput.format(x), yOutput.format(y),
  zOutput.format(z),
  "R" + spatialFormat.format(r)];
}

function onCyclePoint(x, y, z) {
  if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1)) ||
    isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
    gPlaneModal.format(17); // 2-axis lathes typically don't use G17
  } else {
    expandCyclePoint(x, y, z);
    return;
  }

  switch (cycleType) {
    case "thread-turning":
      if (properties.useSimpleThread) {
        var inverted = (toolingData.toolPost == REAR) ? 1 : -1;
        var r = -cycle.incrementalX * inverted; // positive if taper goes down - delta radius
        var threadsPerInch = 1.0 / cycle.pitch; // per mm for metric
        var f = 1 / threadsPerInch;
        writeBlock(
          gMotionModal.format(92),
          xOutput.format(x - cycle.incrementalX),
          yOutput.format(y),
          zOutput.format(z),
          conditional(zFormat.isSignificant(r), g92ROutput.format(r)),
          feedOutput.format(f)
        );
      } else {
        if (isFirstCyclePoint()) {
          localCycle = new ThreadingCycle(x, y, z);
        }
        if (!isLastCyclePoint()) {
          return;
        }

        writeBlock(
          gFormat.format(138),
          threadXBOutput.format(localCycle.start.x), // start position
          threadZBOutput.format(localCycle.start.z),
          threadXMOutput.format(localCycle.bottom),
          threadXEOutput.format(localCycle.end.x), // end position
          threadZEOutput.format(localCycle.end.z),
          threadPOutput.format(localCycle.pitch), // thread pitch
          threadNPOutput.format(localCycle.passes), // number of passes
          threadSPOutput.format(localCycle.springPass), // number of spring passes
          threadAOutput.format(localCycle.infeedAngle), // infeed angle
          threadSIOutput.format(localCycle.external ? 1 : 0), // 0 = internal thread, 1 = external thread
          threadSTOutput.format(localCycle.threadStarts), // number of thread starts
          sOutput.format(spindleSpeed),
          "T" + toolFormat.format(tool.number)
        );
      }
      return;
  }

  if (isFirstCyclePoint()) {
    switch (gPlaneModal.getCurrent()) {
      case 17:
        writeBlock(gMotionModal.format(0), zOutput.format(cycle.clearance));
        break;
      case 18:
        writeBlock(gMotionModal.format(0), yOutput.format(cycle.clearance));
        break;
      case 19:
        writeBlock(gMotionModal.format(0), xOutput.format(cycle.clearance));
        break;
      default:
        error(localize("Unsupported drilling orientation."));
        return;
    }

    repositionToCycleClearance(cycle, x, y, z);

    // return to initial Z which is clearance plane and set absolute mode

    var F = cycle.feedrate;
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
      case "deep-drilling":
        if (P > 0) {
          expandCyclePoint(x, y, z);
        } else {
          writeBlock(
            gCycleModal.format(83),
            getCommonCycle(x, y, z, cycle.retract),
            "Q" + spatialFormat.format(cycle.incrementalDepth),
            // conditional(P > 0, "P" + milliFormat.format(P)),
            feedOutput.format(F)
          );
        }
        break;
      case "boring":
        writeBlock(
          gCycleModal.format(85),
          getCommonCycle(x, y, z, cycle.retract),
          feedOutput.format(F)
        );
        break;
      default:
        expandCyclePoint(x, y, z);
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
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
        g92ROutput.reset();
        break;
      default:
        writeBlock(gCycleModal.format(80));
    }
  }
}

var currentCoolantMode = COOLANT_OFF;

function setCoolant(coolant) {
  if (coolant == currentCoolantMode) {
    return; // coolant is already active
  }

  var m = undefined;
  if (coolant == COOLANT_OFF) {
    writeBlock(getCode("COOLANT_OFF"));
    currentCoolantMode = COOLANT_OFF;
    return;
  }

  switch (coolant) {
    case COOLANT_FLOOD:
      m = getCode("COOLANT_FLOOD_ON");
      break;
    case COOLANT_MIST:
      m = getCode("COOLANT_MIST_ON");
      break;
    default:
      onUnsupportedCoolant(coolant);
      m = getCode("COOLANT_OFF");
  }

  if (m) {
    writeBlock(m);
    currentCoolantMode = coolant;
  }
}

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) {
    startSpindle(false, false, getFramePosition(currentSection.getInitialPosition()), spindleSpeed);
  }
}

function startSpindle(tappingMode, forceRPMMode, initialPosition, rpm) {
  var spindleDir;
  var spindleMode;
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }
  gSpindleModeModal.reset();

  if ((getSpindle() == SPINDLE_SECONDARY) && !gotSecondarySpindle) {
    error(localize("Secondary spindle is not available."));
    return;
  }

  if (false /*tappingMode*/) {
    spindleDir = getCode("RIGID_TAPPING");
  } else {
    if (getSpindle() == SPINDLE_SECONDARY) {
      spindleDir = tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW");
    } else {
      spindleDir = tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW");
    }
  }

  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if (forceRPMMode) { // RPM mode is forced until move to initial position
      _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
    } else {
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON");
    }
  } else {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
  }
  if (getSpindle(true) == SPINDLE_SECONDARY) {
    writeBlock(
      spindleMode,
      sOutput.format(_spindleSpeed),
      spindleDir
    );
  } else {
    writeBlock(
      spindleMode,
      sOutput.format(_spindleSpeed),
      spindleDir
    );
  }
  // wait for spindle here if required
}

function onCommand(command) {
  switch (command) {
    case COMMAND_COOLANT_OFF:
      setCoolant(COOLANT_OFF);
      return;
    case COMMAND_COOLANT_ON:
      setCoolant(COOLANT_FLOOD);
      return;
    case COMMAND_LOCK_MULTI_AXIS:
      return;
    case COMMAND_UNLOCK_MULTI_AXIS:
      return;
    case COMMAND_START_CHIP_TRANSPORT:
      // getCode("START_CHIP_TRANSPORT");
      return;
    case COMMAND_STOP_CHIP_TRANSPORT:
      // getCode("STOP_CHIP_TRANSPORT");
      return;
    case COMMAND_BREAK_CONTROL:
      return;
    case COMMAND_TOOL_MEASURE:
      return;
    case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
      return;
    case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
      return;
    case COMMAND_STOP:
      writeBlock(mFormat.format(0));
      forceSpindleSpeed = true;
      return;
    case COMMAND_OPTIONAL_STOP:
      writeBlock(mFormat.format(1));
      break;
    case COMMAND_END:
      writeBlock(mFormat.format(2));
      break;
    case COMMAND_SPINDLE_CLOCKWISE:
      switch (currentSection.spindle) {
        case SPINDLE_PRIMARY:
          writeBlock(mFormat.format(3));
          break;
        // case SPINDLE_SECONDARY:
        // writeBlock(mFormat.format(143));
        // break;
      }
      break;
    case COMMAND_SPINDLE_COUNTERCLOCKWISE:
      switch (currentSection.spindle) {
        case SPINDLE_PRIMARY:
          writeBlock(mFormat.format(4));
          break;
        // case SPINDLE_SECONDARY:
        // writeBlock(mFormat.format(144));
        // break;
      }
      break;
    case COMMAND_START_SPINDLE:
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
      return;
    case COMMAND_STOP_SPINDLE:
      switch (currentSection.spindle) {
        case SPINDLE_PRIMARY:
          writeBlock(mFormat.format(5));
          break;
        // case SPINDLE_SECONDARY:
        // writeBlock(mFormat.format(145));
        // break;
      }
      break;
    case COMMAND_ORIENTATE_SPINDLE:
      if (getSpindle() == 0) {
        writeBlock(mFormat.format(19)); // use P or R to set angle (optional)
      } else {
        writeBlock(mFormat.format(119));
      }
      break;
    //case COMMAND_CLAMP: // TAG: add support for clamping
    //case COMMAND_UNCLAMP: // TAG: add support for clamping
    default:
      onUnsupportedCommand(command);
  }
}

/*
function engagePartCatcher(engage) {
  if (engage) {
    // catch part here
    writeBlock(getCode("PART_CATCHER_ON"), formatComment(localize("PART CATCHER ON")));
  } else {
    onCommand(COMMAND_COOLANT_OFF);
    writeBlock(gFormat.format(28), gMotionModal.format(0), "U" + xFormat.format(properties.g53HomePositionX)); // retract
    writeBlock(gFormat.format(28), gMotionModal.format(0), "W" + zFormat.format(properties.g53HomePositionZ)); // retract
    writeBlock(getCode("PART_CATCHER_OFF"), formatComment(localize("PART CATCHER OFF")));
    forceXYZ();
  }
}
*/

function onSectionEnd() {

  // cancel SFM mode to preserve spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, true, getFramePosition(currentSection.getFinalPosition()));
  }

  /*
    if (currentSection.partCatcher) {
      engagePartCatcher(false);
    }
  */
  forceAny();
}

function onClose() {
  writeln("");

  optionalSection = false;

  onCommand(COMMAND_COOLANT_OFF);

  onCommand(COMMAND_STOP_CHIP_TRANSPORT);

  // we might want to retract in Z before X
  // writeBlock(gFormat.format(28), "U" + xFormat.format(0)); // retract

  forceXYZ();
  if (!machineConfiguration.hasHomePositionX() && !machineConfiguration.hasHomePositionY()) {
    // writeBlock(gFormat.format(28), "U" + xFormat.format(0), conditional(yOutput.isEnabled(), "V" + yFormat.format(0)), "W" + zFormat.format(0)); // return to home
  } else {
    var homeX;
    if (machineConfiguration.hasHomePositionX()) {
      homeX = xOutput.format(machineConfiguration.getHomePositionX());
    }
    var homeY;
    if (yOutput.isEnabled() && machineConfiguration.hasHomePositionY()) {
      homeY = yOutput.format(machineConfiguration.getHomePositionY());
    }
    // writeBlock(gFormat.format(53), gMotionModal.format(0), homeX, homeY, zOutput.format(machineConfiguration.getRetractPlane()));
  }

  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
  writeln("%");
}
