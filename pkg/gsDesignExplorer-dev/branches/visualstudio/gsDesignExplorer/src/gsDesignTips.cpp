// Copyright (C) 2009 Merck Research Laboratories and REvolution Computing, Inc.
//
//	This file is part of gsDesignExplorer.
//
//  gsDesignExplorer is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  gsDesignExplorer is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with gsDesignExplorer.  If not, see <http://www.gnu.org/licenses/>.
#include "gsdesign.h"
#include "ui_gsdesign.h"
#include "GsRList.h"

void gsDesign::setHelpTips()
{
// Analysis tab
  // Group tab
  ui->analysisTab->setToolTip(tr("Enter interim analysis sample sizes on this page."));
  ui->analysisTab->setStatusTip(tr("Enter interim analysis sample sizes on this page."));
  ui->analysisTab->setWhatsThis(tr("Enter interim analysis sample sizes on this page."));
  
  // Type I Error	
  ui->anlErrorDSpin->setToolTip(tr("0 < Type I Error < Power < 100"));
  ui->anlErrorDSpin->setStatusTip(tr("Total Type I error summed across all analyses. Default = 2.5%"));
  ui->anlErrorDSpin->setWhatsThis(tr("Probability (in percent) of crossing the upper boundary under the null hypothesis."));
  
  // Fixed samplesize	
  ui->anlMaxSampleSizeSpin->setToolTip(tr("Maximum sample size"));
  ui->anlMaxSampleSizeSpin->setStatusTip(tr("Maximum sample size"));
  ui->anlMaxSampleSizeSpin->setWhatsThis(tr("Maximum sample size"));
  
  // Power	
  ui->anlPowerDSpin->setToolTip(tr("0 < Type I Error < Power < 100"));
  ui->anlPowerDSpin->setStatusTip(tr("Power = 1 - Beta, where Beta is the Type II error summed across all analyses."));
  ui->anlPowerDSpin->setWhatsThis(tr("Power = 1 - Beta, where Beta is the Type II error summed across all analyses. Default = 90%."));
  
  // Sample size table	
  ui->anlSampleSizeTable->setToolTip(tr("Sample size table"));	
  ui->anlSampleSizeTable->setStatusTip(tr("Sample size table"));	
  ui->anlSampleSizeTable->setWhatsThis(tr("Sample size table"));

  // Lock times button

  ui->anlLockTimesRadio->setToolTip(tr("Lock the table so values cannot change"));	
  ui->anlLockTimesRadio->setStatusTip(tr("Lock the table so that the table is nor repopulated when the design is run."));	
  ui->anlLockTimesRadio->setWhatsThis(tr("If not checked, the table is unlocked and will be repopulated with values "
	  "as returned by running the current design while in analysis mode. "
	  "If checked, the table is locked and running the current design while in Analysis mode will not repopulate "
	  "the table values. This latter aspect is desirable, for example, when you want to control the "
	  "samples/analyses directly rather than having the code return arbitrary, valid values."));

  // Design Navigator
  // Group tab	
  ui->designTab->setToolTip(tr("Specify Type I Error, Power, and Timing"));
  ui->designTab->setStatusTip(tr("Specify Type I Error, Power, and Timing"));
  ui->designTab->setWhatsThis(tr("Use the Design Navigator to specify all the parameters "
	  "necessary to create a group sequential design. The alpha-Power-Timing tab allows "
	  "you to specify alpha, the Type I error, and the power of the design, 1-beta, where "
	  "beta is the Type II error. You also use this tab to specify the timing of interim "
	  "analyses."));
  
  // Add a new design	
 // ui->dnAddPush->setToolTip(tr(""));
 // ui->dnAddPush->setStatusTip(tr(""));
 // ui->dnAddPush->setWhatsThis(tr(""));
  
  // Remove current design	
  //ui->dnRemovePush->setToolTip(tr(""));
  // Design/Analysis/Simulation selector	
  ui->dnModeCombo->setToolTip(tr(""));
  //Loaded designs selector	
  ui->dnNameCombo->setToolTip(tr(""));
  // Loaded design descriptions selector
  ui->dnDescCombo->setToolTip(tr(""));

// Error, Power, and Timing
  // Type I Error	
  ui->eptErrorDSpin->setToolTip(tr("0 < Type I Error < Power < 100"));
  ui->eptErrorDSpin->setStatusTip(tr("Total Type I error summed across all analyses. Default = 2.5%"));
  ui->eptErrorDSpin->setWhatsThis(tr("Probability (in percent) of crossing the upper boundary "
	  "under the null hypothesis. Type I error is always one-sided."));

  // Number of intervals
  ui->eptIntervalsSpin->setToolTip(tr("Must be > 0."));
  ui->eptIntervalsSpin->setStatusTip(tr("Number of interim analyses (in addition to final). Must be > 0."));
  ui->eptIntervalsSpin->setWhatsThis(tr("Specify the number of interim analyses, in addition "
	  "to the final analysis. If number of interim analyses is set too high, an error will occur "
	  "because false negative rates cannot be achieved."));

  // Power
  ui->eptPowerDSpin->setToolTip(tr("0 < Type I Error < Power < 100"));
  ui->eptPowerDSpin->setStatusTip(tr("Power = 1 - Beta, where Beta is the Type II error summed across all analyses."));
  ui->eptPowerDSpin->setWhatsThis(tr("Power = 1 - Beta, where Beta is the Type II error summed "
	  "across all analyses. Default = 90%."));

  // Spacing	
  ui->eptSpacingCombo->setToolTip(tr("Interim analyses timing: Equal or Unequal"));
  ui->eptSpacingCombo->setStatusTip(tr("Automatically calculate timings with Equal spacing, or specify Unequal."));
  ui->eptSpacingCombo->setWhatsThis(tr(""));

  // Timing table
  ui->eptTimingTable->setToolTip(tr("Increasing values in (0, 1)"));
  ui->eptTimingTable->setStatusTip(tr("Proportion of sample size or events at each interim."));
  ui->eptTimingTable->setWhatsThis(tr("The values specified in the Timing control correspond to "
	  "the cumulative proportion of statistical information (e.g., sample size or events) "
	  "available for the data analyzed at each interim analysis.  For example, the default "
	  "of 2 equally spaced interim analyses corresponds to analysis performed after 33.3% "
	  "and 66.7% of the way through the trial."));

// Lower Spending	
  // Spending Function subtab group (applies to both lower + upper)
  ui->spendingFunctionTab->setToolTip(tr("Specify the spending function."));
  ui->spendingFunctionTab->setStatusTip(tr("Specify the spending function."));
  ui->spendingFunctionTab->setWhatsThis(tr("Specify the spending function."));

  // Test type	
  ui->sflTestCombo->setToolTip(tr("Lower spending test type"));
  ui->sflTestCombo->setStatusTip(tr("Lower spending test type"));
  ui->sflTestCombo->setWhatsThis(tr("Specify the information for the test type. "
	  "You can have:"
	  "<ul>"
	  "<li>one-sided," 
	  "<li>two-sided symmetric,"
	  "<li>two-sided asymmetric beta-spending with binding lower bound," 
	  "<li>two-sided asymmetric beta-spending with non-binding lower bound,"
	  "<li>two-sided asymmetric lower bound spending under the null hypothesis with binding lower bound, or"
	  "<li>two-sided asymmetric lower bound spending under the null hypothesis with non-binding lower bound."
	  "</ul>"));

    // Lower bound spending	
  ui->sflLBSCombo->setToolTip(tr("Lower bound spending for 2-sided futility test type"));
  ui->sflLBSCombo->setStatusTip(tr("Choose beta spending or lower bound spending under the null hypothesis"));
  ui->sflLBSCombo->setWhatsThis(tr("<ul>"
	  "<li><b>Beta-spending</b> refers to error spending for the lower bound "
	  "crossing probabilities under the alternative hypothesis. In this case, the final analysis "
	  "lower and upper boundaries are assumed to be the same. The appropriate total beta spending "
	  "(power) is determined by adjusting the maximum sample size through an iterative process for "
	  "all options. Since beta-spending must compute boundary crossing probabilities under both the "
	  "null and alternative hypotheses, deriving these designs can take longer than other options. "
	  "<li>Alternatively you can choose to compute lower bound spending under the <b>null hypothesis</b>."
	  "</ul>"));
 
   // Lower bound testing	
  ui->sflLBTCombo->setToolTip(tr("Choose binding or nonbinding testing"));
  ui->sflLBTCombo->setStatusTip(tr("With nonbinding testing, Type I Error ignores lower bound"));
  ui->sflLBTCombo->setWhatsThis(tr("<ul>"
	  "<li><b>Binding</b> lower bound testing assumes the trial stops if the lower bound "
	  "is crossed for Type I and Type II error computation. "
	  "<li><b>Non-binding</b> lower bound testing assumes the trial continues if the "
	  "lower bound is crossed, for the purpose of computing Type I error; "
	  "that is a Type I error can be made by crossing an upper bound after crossing a "
	  "previous lower bound."
	  "</ul>"));
  
  // Spending function lower stacked widget selector
  ui->sflParamToolBox->setToolTip(tr("Lower bound spending function"));
  ui->sflParamToolBox->setStatusTip(tr("Lower bound spending function"));
  ui->sflParamToolBox->setWhatsThis(tr("Lower bound spending function"));

  // Lan-DeMets approx
  ui->sfl0PCombo->setToolTip(tr("Choose O'Brien-Fleming or Pocock design"));
  ui->sfl0PCombo->setToolTip(tr("Lan-DeMets approximation to O'Brien-Fleming or Pocock design"));
  ui->sfl0PCombo->setWhatsThis(tr("Generalization of the Lan-DeMets spending function used to approximate an O'Brien-Fleming or Pocock spending function."));
  
  //1-param function	
  ui->sfl1PCombo->setToolTip(tr("Select 1-parameter family"));
  ui->sfl1PCombo->setStatusTip(tr("Select 1-parameter family"));
  ui->sfl1PCombo->setWhatsThis(tr("Select 1-parameter family. The default is the Hwang-Shih-DeCani spending function."));

  //1-param value	
  ui->sfl1PDSpin->setToolTip(tr("Specify spending function parameter"));
  ui->sfl1PDSpin->setStatusTip(tr("Specify spending function parameter"));
  ui->sfl1PDSpin->setWhatsThis(tr("Specify spending function parameter"
	  "<ul>"
	  "<li>For Hwang-Shih-DeCani the parameter must be in the [-40, 40) range. "
	  "<li>For Power, the parameter must be in the (0,+infinity) range."
	  "<li>For Exponential, the parameter must be in the (0, 10] range but is recommended to be less than 1."
	  "</ul>"));
  
   // Spending function lower 2-parameter tab	
  ui->sfl2PTab->setToolTip(tr("2-parameter spending functions"));
  ui->sfl2PTab->setStatusTip(tr("2-parameter spending functions"));
  ui->sfl2PTab->setWhatsThis(tr("2-parameter spending functions"));

  // 2-param function	
  ui->sfl2PFunCombo->setToolTip(tr("Select function to adjust spending shape"));
  ui->sfl2PFunCombo->setStatusTip(tr("Select function to adjust spending shape"));
  ui->sfl2PFunCombo->setWhatsThis(tr("Select function to adjust spending shape"));

 // 2-param function 1st point X
  ui->sfl2PPt1XDSpin->setToolTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfl2PPt1XDSpin->setStatusTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfl2PPt1XDSpin->setWhatsThis(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));

  // 2-param function 1st point Y
  ui->sfl2PPt1YDSpin->setToolTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfl2PPt1YDSpin->setStatusTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfl2PPt1YDSpin->setWhatsThis(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));

  // 2-param function 2nd point X
  ui->sfl2PPt2XDSpin->setToolTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfl2PPt2XDSpin->setStatusTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfl2PPt2XDSpin->setWhatsThis(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));

  // 2-param function 2nd point Y
  ui->sfl2PPt2YDSpin->setToolTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfl2PPt2YDSpin->setStatusTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfl2PPt2YDSpin->setWhatsThis(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  	
   // 2-param linear model intercept value
  ui->sfl2PLMIntDSpin->setToolTip(tr("Specify real value for intercept"));
  ui->sfl2PLMIntDSpin->setStatusTip(tr("Specify real value for intercept"));
  ui->sfl2PLMIntDSpin->setWhatsThis(tr("Specify real value for intercept"));

  // 2-param linear model slope value
  ui->sfl2PLMSlpDSpin->setToolTip(tr("Specify positive value for slope"));
  ui->sfl2PLMSlpDSpin->setStatusTip(tr("Specify positive value for slope"));
  ui->sfl2PLMSlpDSpin->setWhatsThis(tr("Specify positive value for slope"));
    
  // Spending function upper 3-parameter tab group
  ui->sfl3PTab->setToolTip(tr("3-parameter spending functions"));
  ui->sfl3PTab->setStatusTip(tr("3-parameter spending functions"));
  ui->sfl3PTab->setWhatsThis(tr("3-parameter spending functions"));
  
  // 3-param linear model intercept value
  ui->sfl3PLMIntDSpin->setToolTip(tr("Specify a real value for intercept"));
  ui->sfl3PLMIntDSpin->setStatusTip(tr("Specify a real value for intercept"));
  ui->sfl3PLMIntDSpin->setWhatsThis(tr("Specify a real value for the intercept"));

  // 3-param linear model slope value
  ui->sfl3PLMSlpDSpin->setToolTip(tr("Specify a positive value for the slope"));
  ui->sfl3PLMSlpDSpin->setStatusTip(tr("Specify a positive value for the slope"));
  ui->sfl3PLMSlpDSpin->setWhatsThis(tr("Specify a positive value for the slope"));
 
  // 3-param linear model degrees of freedom
  ui->sfl3PLMDfDSpin->setToolTip(tr("Specify a real value of 1 or greater"));
  ui->sfl3PLMDfDSpin->setStatusTip(tr("Specify a real value of 1 or greater"));
  ui->sfl3PLMDfDSpin->setWhatsThis(tr("Specify a real value of 1 or greater"));

  // 3-param function 1st point X
  ui->sfl3PPt1XDSpin->setToolTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfl3PPt1XDSpin->setStatusTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfl3PPt1XDSpin->setWhatsThis(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));

  // 3-param function 1st point Y
  ui->sfl3PPt1YDSpin->setToolTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfl3PPt1YDSpin->setStatusTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfl3PPt1YDSpin->setWhatsThis(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));

  // 3-param function 2nd point X
  ui->sfl3PPt2XDSpin->setToolTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfl3PPt2XDSpin->setStatusTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfl3PPt2XDSpin->setWhatsThis(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));

  // 3-param function 2nd point Y
  ui->sfl3PPt2YDSpin->setToolTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfl3PPt2YDSpin->setStatusTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfl3PPt2YDSpin->setWhatsThis(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));

  // 3-param points degrees of freedom
  ui->sfl3PPtsDfDSpin->setToolTip(tr("Specify a real value of 1 or greater"));
  ui->sfl3PPtsDfDSpin->setStatusTip(tr("Specify a real value of 1 or greater"));
  ui->sfl3PPtsDfDSpin->setWhatsThis(tr("Specify a real value of 1 or greater"));

   // Piecewise linear points specification table for X values
  ui->sflPieceTableX->setToolTip(tr("X values for points with increasing values from 0 to 1, inclusive"));
  ui->sflPieceTableX->setStatusTip(tr("X values for points with increasing values from 0 to 1, inclusive"));
  ui->sflPieceTableX->setWhatsThis(tr("X values for points with increasing values from 0 to 1, inclusive"));
  
  // Piecewise linear points specification table for Y values
  ui->sflPieceTableY->setToolTip(tr("Y values for points with increasing values from 0 to 1, inclusive1"));
  ui->sflPieceTableY->setStatusTip(tr("Y values for points with increasing values from 0 to 1, inclusive1"));
  ui->sflPieceTableY->setWhatsThis(tr("Y values for points with increasing values from 0 to 1, inclusive"));
  
  //Piecewise linear #points 	
  ui->sflPiecePtsSpin->setToolTip(tr("Specifiy the number of points"));
  ui->sflPiecePtsSpin->setStatusTip(tr("Specifiy the number of points"));
  ui->sflPiecePtsSpin->setWhatsThis(tr("Specifiy the number of points. The last point "
   "should be 1. Points represent the values of the proportion of sample size/information for which "
   "the spending function will be computed."));

  // Piecewise linear user interim radio box
  ui->sflPieceUseInterimRadio->setToolTip(tr("Select to use interim timing"));
  ui->sflPieceUseInterimRadio->setStatusTip(tr("Select to use interim timing"));
  ui->sflPieceUseInterimRadio->setWhatsThis(tr("Select to use interim timing"));

// Upper Spending

   //Spending function upper stacked widget selector
  ui->sfuParamToolBox->setToolTip(tr("Set upper bound spending function and parameters"));
  ui->sfuParamToolBox->setStatusTip(tr("Set upper bound spending function and parameters"));
  ui->sfuParamToolBox->setWhatsThis(tr("Set upper bound spending function and parameters"));

  // Lan-DeMets approx for parameter free spending function
  ui->sfu0PCombo->setToolTip(tr("Choose O'Brien-Fleming or Pocock design"));
  ui->sfu0PCombo->setStatusTip(tr("Choose approximation to O'Brien-Fleming or Pocock design"));
  ui->sfu0PCombo->setWhatsThis(tr("Choose approximation to O'Brien-Fleming or Pocock design"));

  // 1-param function
  ui->sfu1PCombo->setToolTip(tr("Select 1-parameter family"));
  ui->sfu1PCombo->setStatusTip(tr("Select 1-parameter family"));
  ui->sfu1PCombo->setWhatsThis(tr("Select 1-parameter family. The default is the Hwang-Shih-DeCani spending function."));

  // 1-param value
  ui->sfu1PDSpin->setToolTip(tr("Specify spending function parameter"));
  ui->sfu1PDSpin->setStatusTip(tr("Specify spending function parameter"));
  ui->sfu1PDSpin->setWhatsThis(tr("Specify spending function parameter."
	  "<ul>"
	  "<li>For Hwang-Shih-DeCani the parameter must be in the [-40, 40) range. -4 is O'Brien-Fleming like; 1 is Pocock like"
	  "<li>For Power, the parameter must be in the (0,+infinity) range. 3 is O'Brien-Fleming like; 1 is Pocock like"
	  "<li>For Exponential, the parameter must be in the (0, 10] range but is recommended to be less than 1. 0.75 is O'Brien-Fleming like"
	  "</ul>"));

  // Spending function upper 2-parameter tab group
  ui->sfu2PTab->setToolTip(tr("2-parameter spending functions"));
  ui->sfu2PTab->setStatusTip(tr("2-parameter spending functions"));
  ui->sfu2PTab->setWhatsThis(tr("When designing a clinical trial with interim analyses, the rules for stopping the trial at an interim "
	  "analysis for a positive or a negative efficacy result must fit the medical, ethical, regulatory and "
      "statistical situation that is presented. Once a general strategy has been chosen, it is not unreasonable "
      "to discuss precise boundaries at each interim analysis that would be considered ethical for the purpose "
      "of continuing or stopping a trial. Commonly used one-parameter families may not provide an adequate fit to "
	  "multiple desired critical values.  Two-parameter families provide additional exibility."));

  // 2-param function
  ui->sfu2PFunCombo->setToolTip(tr("Select function to adjust spending shape"));
  ui->sfu2PFunCombo->setStatusTip(tr("Select function to adjust spending shape"));
  ui->sfu2PFunCombo->setWhatsThis(tr("Select function to adjust spending shape. "
	  "Choices are:"
	  "<ul> "
	  "<li> Beta distribution"
	  "<li> Cauchy"
	  "<li> Extreme value"
	  "<li> Extreme value (2)"
	  "<li> Logistic"
	  "<li> Normal"
	  "</ul"));

  // 2-param function 1st point X
  ui->sfu2PPt1XDSpin->setToolTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfu2PPt1XDSpin->setStatusTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfu2PPt1XDSpin->setWhatsThis(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));

  // 2-param function 1st point Y
  ui->sfu2PPt1YDSpin->setToolTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfu2PPt1YDSpin->setStatusTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfu2PPt1YDSpin->setWhatsThis(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));

  // 2-param function 2nd point X
  ui->sfu2PPt2XDSpin->setToolTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfu2PPt2XDSpin->setStatusTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfu2PPt2XDSpin->setWhatsThis(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));

  // 2-param function 2nd point Y
  ui->sfu2PPt2YDSpin->setToolTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfu2PPt2YDSpin->setStatusTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfu2PPt2YDSpin->setWhatsThis(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));

  // 2-param linear model intercept value
  ui->sfu2PLMIntDSpin->setToolTip(tr("Specify real value for intercept"));
  ui->sfu2PLMIntDSpin->setStatusTip(tr("Specify real value for intercept"));
  ui->sfu2PLMIntDSpin->setWhatsThis(tr("Specify real value for intercept"));

  // 2-param linear model slope value
  ui->sfu2PLMSlpDSpin->setToolTip(tr("Specify positive value for slope"));
  ui->sfu2PLMSlpDSpin->setStatusTip(tr("Specify positive value for slope"));
  ui->sfu2PLMSlpDSpin->setWhatsThis(tr("Specify positive value for slope"));

   // Spending function upper 3-parameter tab group
  ui->sfu3PTab->setToolTip(tr("3-parameter spending functions"));
  ui->sfu3PTab->setStatusTip(tr("3-parameter spending functions"));
  ui->sfu3PTab->setWhatsThis(tr("3-parameter spending functions"));

  // 3-param linear model intercept value
  ui->sfu3PLMIntDSpin->setToolTip(tr("Specify a real value for intercept"));
  ui->sfu3PLMIntDSpin->setStatusTip(tr("Specify a real value for intercept"));
  ui->sfu3PLMIntDSpin->setWhatsThis(tr("Specify a real value for the intercept"));

  // 3-param linear model slope value
  ui->sfu3PLMSlpDSpin->setToolTip(tr("Specify a positive value for the slope"));
  ui->sfu3PLMSlpDSpin->setStatusTip(tr("Specify a positive value for the slope"));
  ui->sfu3PLMSlpDSpin->setWhatsThis(tr("Specify a positive value for the slope"));

  // 3-param linear model degrees of freedom
  ui->sfu3PLMDfDSpin->setToolTip(tr("Specify a real value of 1 or greater"));
  ui->sfu3PLMDfDSpin->setStatusTip(tr("Specify a real value of 1 or greater"));
  ui->sfu3PLMDfDSpin->setWhatsThis(tr("Specify a real value of 1 or greater"));

   // 3-param function 1st point X
  ui->sfu3PPt1XDSpin->setToolTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfu3PPt1XDSpin->setStatusTip(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));
  ui->sfu3PPt1XDSpin->setWhatsThis(tr("Enter the x value for the first point: 0 < x1 < x2 < 1"));

  // 3-param function 1st point Y
  ui->sfu3PPt1YDSpin->setToolTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfu3PPt1YDSpin->setStatusTip(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));
  ui->sfu3PPt1YDSpin->setWhatsThis(tr("Enter the y value for the first point: 0 < y1 < y2 < 1"));

  // 3-param function 2nd point X
  ui->sfu3PPt2XDSpin->setToolTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfu3PPt2XDSpin->setStatusTip(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));
  ui->sfu3PPt2XDSpin->setWhatsThis(tr("Enter the x value for the second point: 0 < x1 < x2 < 1"));

  // 3-param function 2nd point Y
  ui->sfu3PPt2YDSpin->setToolTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfu3PPt2YDSpin->setStatusTip(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));
  ui->sfu3PPt2YDSpin->setWhatsThis(tr("Enter the y value for the second point: 0 < y1 < y2 < 1"));

  // 3-param points degrees of freedom
  ui->sfu3PPtsDfDSpin->setToolTip(tr("Specify a real value of 1 or greater"));
  ui->sfu3PPtsDfDSpin->setStatusTip(tr("Specify a real value of 1 or greater"));
  ui->sfu3PPtsDfDSpin->setWhatsThis(tr("Specify a real value of 1 or greater"));

  // Piecewise linear points specification table for X values
  ui->sfuPieceTableX->setToolTip(tr("X values for points with increasing values from 0 to 1, inclusive"));
  ui->sfuPieceTableX->setStatusTip(tr("X values for points with increasing values from 0 to 1, inclusive"));
  ui->sfuPieceTableX->setWhatsThis(tr("X values for points with increasing values from 0 to 1, inclusive"));
  
  // Piecewise linear points specification table for Y values
  ui->sfuPieceTableY->setToolTip(tr("Y values for points with increasing values from 0 to 1, inclusive1"));
  ui->sfuPieceTableY->setStatusTip(tr("Y values for points with increasing values from 0 to 1, inclusive1"));
  ui->sfuPieceTableY->setWhatsThis(tr("Y values for points with increasing values from 0 to 1, inclusive"));
  
  //Piecewise linear #points 	
  ui->sfuPiecePtsSpin->setToolTip(tr("Specifiy the number of points"));
  ui->sfuPiecePtsSpin->setStatusTip(tr("Specifiy the number of points"));
  ui->sfuPiecePtsSpin->setWhatsThis(tr("Specifiy the number of points. The last point "
   "should be 1. Points represent the values of the proportion of sample size/information for which "
   "the spending function will be computed."));

  // Piecewise linear user interim radio box
  ui->sfuPieceUseInterimRadio->setToolTip(tr("Select to user interim timing"));
  ui->sfuPieceUseInterimRadio->setStatusTip(tr("Select to user interim timing"));
  ui->sfuPieceUseInterimRadio->setWhatsThis(tr("Select to user interim timing"));

// Sample Size	
  // subtab group
  ui->sampleSizeTab->setToolTip(tr("Specify or calculate the required sample size"));
  ui->sampleSizeTab->setStatusTip(tr("Specify or calculate the required sample size"));
  ui->sampleSizeTab->setWhatsThis(tr("Specify or calculate the required sample size for a fixed design "
	  "with no interim analyses and the same Type I error and power you specified for your group "
	  "sequential design. This fixed design is then used to generate the sample size for a group "
	  "sequential design. "
	  "<ul>"
	  "<li>The <b>User Input</b> "
	  "tab allows you to enter a sample size." 
	  "<li>On the <b>Binomial</b> tab specify event rates for the control "
	  "and experimental test groups. "
	  "<li>The <b>Time to Event</b> tab allows you to calculate the sample size and "
	  "required number of events for a trial."
	  "</ul>"));
 
  // Fixed design sample size

  ui->ssUserFixedSpin->setToolTip(tr("Set the fixed sample size."));
  ui->ssUserFixedSpin->setStatusTip(tr("Sample size for design with no interim analysis"));
  ui->ssUserFixedSpin->setWhatsThis(tr("Sample size for design with no interim analysis."
	  "Setting it to 1 results in a `generic' design that may be used with "
	  "any sampling situation. Sample size ratios are provided and the user multiplies "
	  "these times the sample size for a fixed design to obtain the corresponding group "
	  "sequential analysis times."));

  // Binomial Randomization ratio
  ui->ssBinRatioDSpin->setToolTip(tr("Experimental/Control relative sample size"));
  ui->ssBinRatioDSpin->setStatusTip(tr("Experimental/Control relative sample size. The default is 1.0"));
  ui->ssBinRatioDSpin->setWhatsThis(tr("Experimental/Control relative sample size. The default is 1.0"));

  // Binomial Control rate
  ui->ssBinControlDSpin->setToolTip(tr(">0, <1"));
  ui->ssBinControlDSpin->setStatusTip(tr("Control event rate. The default is .15"));
   ui->ssBinControlDSpin->setWhatsThis(tr("Event rate in the control group. The default is .15"));

  // Binomial Experimental rate
  ui->ssBinExpDSpin->setToolTip(tr(">0, <1"));
  ui->ssBinExpDSpin->setStatusTip(tr("Experimental event rate. The default is .1"));
  ui->ssBinExpDSpin->setWhatsThis(tr("Event rate in the experimental group. The default is .1"));

  // Superiority/inferiority
  ui->ssBinSupCombo->setToolTip(tr("Specify 'Superiority' or 'Non-inferiority - Superiority with margin'"));
  ui->ssBinSupCombo->setStatusTip(tr("Specify 'Superiority' or 'Non-inferiority - Superiority with margin'"));
  ui->ssBinSupCombo->setWhatsThis(tr("Specify 'Superiority' or 'Non-inferiority - Superiority with margin'"));
  
  // Margin for treatment difference
  ui->ssBinDeltaDSpin->setToolTip(tr("Margin for treatment difference"));
  ui->ssBinDeltaDSpin->setStatusTip(tr("Margin for treatment difference"));
  ui->ssBinDeltaDSpin->setWhatsThis(tr("Margin for treatment difference"));
 
  // Binomial fixed design sample size (read only)
  ui->ssBinFixedSpin->setToolTip(tr("Sample size computed using Lachin and Foulkes (1986)."));
  ui->ssBinFixedSpin->setStatusTip(tr("Sample size computed using Lachin and Foulkes (1986)."));
  ui->ssBinFixedSpin->setWhatsThis(tr("Sample size computed using Lachin and Foulkes (1986)."));

  // Time to Event
  // Time to Event rate/median time switch	
  ui->ssTESwitchCombo->setToolTip(tr("Select median time or event rate"));
  ui->ssTESwitchCombo->setStatusTip(tr("Select median time or event rate"));
  ui->ssTESwitchCombo->setWhatsThis(tr("Select median time or event rate"));

  // Time to Event Control rate/median time
  ui->ssTECtrlDSpin->setToolTip(tr("The time to a primary endpoint for the control group."));
  ui->ssTECtrlDSpin->setStatusTip(tr("The time to a primary endpoint or the control group."));
  ui->ssTECtrlDSpin->setWhatsThis(tr("The time to a primary endpoint for the control group, specified as either "
	  "an event rate or as the median time-to-event."));
  
  // Time to Event Experimental rate/median time
  ui->ssTEExpDSpin->setToolTip(tr("The median time or event rate for the experimental group."));
  ui->ssTEExpDSpin->setStatusTip(tr("The median time or event rate to a primary endpoint for the experimental group."));
  ui->ssTEExpDSpin->setWhatsThis(tr("The median time or event rate to a primary endpoint for the experimental group."));

  // Time to Event Dropout rate/median time	
  ui->ssTEDropoutDSpin->setToolTip(tr("Equal dropout hazard rate for both groups"));
  ui->ssTEDropoutDSpin->setStatusTip(tr("Equal dropout hazard rate time for both groups"));
  ui->ssTEDropoutDSpin->setWhatsThis(tr("Equal dropout hazard rate for both groups"));

  // Time to Event accrual
  ui->ssTEAccrualDSpin->setToolTip(tr("Accrual (recruitment) duration"));
  ui->ssTEAccrualDSpin->setStatusTip(tr("Accrual (recruitment) duration"));
  ui->ssTEAccrualDSpin->setWhatsThis(tr("Accrual (recruitment) duration"));

  // Time to Event minimum follow-up
  ui->ssTEFollowDSpin->setToolTip(tr("Time to event minimal follow-up"));
  ui->ssTEFollowDSpin->setStatusTip(tr("Time to event minimal follow-up"));
  ui->ssTEFollowDSpin->setWhatsThis(tr("Time to event minimal follow-up"));

  // Time to Event Randomization ratio
   ui->ssTERatioDSpin->setToolTip(tr("Randomization ratio between placebo and treatment group"));
   ui->ssTERatioDSpin->setStatusTip(tr("Randomization ratio between placebo and treatment group"));
   ui->ssTERatioDSpin->setWhatsThis(tr("Randomization ratio between placebo and treatment group. Default is balanced "
       "design, i.e., randomization ratio is 1"));

  // Time to Event hypothesis
  ui->ssTEHypCombo->setToolTip(tr("Type of sample size calculation"));
  ui->ssTEHypCombo->setStatusTip(tr("Type of sample size calculation: risk ratio or risk difference"));
  ui->ssTEHypCombo->setWhatsThis(tr("Type of sample size calculation: risk ratio or risk difference"));

  // Time to Event accrual type (e.g, uniform)
  ui->ssTEAccrualCombo->setToolTip(tr("Patient entry type"));
  ui->ssTEAccrualCombo->setStatusTip(tr("Patient entry type"));
  ui->ssTEAccrualCombo->setWhatsThis(tr("Patient entry type: uniform entry or exponential entry."));

  // Time to Event gamma value
  ui->ssTEGammaDSpin->setToolTip(tr("Rate parameter for exponential entry"));
  ui->ssTEGammaDSpin->setStatusTip(tr("Rate parameter for exponential entry"));
  ui->ssTEGammaDSpin->setWhatsThis(tr("Non-zero rate parameter for exponential entry. (Not applicable if type is uniform.)"));

  // Time to Event fixed design sample size (read only)
  ui->ssTEFixedSpin->setToolTip(tr("Fixed design sample size (read only)"));
  ui->ssTEFixedSpin->setStatusTip(tr("Fixed design sample size (read only)"));
  ui->ssTEFixedSpin->setWhatsThis(tr("Fixed design sample size (read only)"));

  // Time to Event fixed design number of events (read only)
  ui->ssTEFixedEventSpin->setToolTip(tr("Fixed design number of events (read only)"));	
  ui->ssTEFixedEventSpin->setStatusTip(tr("Fixed design number of events (read only)"));	
  ui->ssTEFixedEventSpin->setWhatsThis(tr("Fixed design number of events (read only)"));	
// Output	
  // Output	
  // Save Plot Script
  ui->outputTab->setToolTip(tr("Save Commands"));
  ui->outputTab->setStatusTip(tr("Save commands to regenerate plot"));
  ui->outputTab->setWhatsThis(tr("Save commands to regenerate plot as an R script file."));
  
  // Title	
  ui->opTitleLine->setToolTip(tr("Specify plot title. Leave blank for default."));
    ui->opTitleLine->setStatusTip(tr("Specify the plot title. Leave entry blank for default title."));
  ui->opTitleLine->setWhatsThis(tr("Enter the main title for the plot. Leave the entry blank to "
	  "have the title created automatically."));
  // x-axis label	
  ui->opXLabelLine->setToolTip(tr("Specify the x-axis label. Leave blank for default."));
  ui->opXLabelLine->setStatusTip(tr("Specify the x-axis label. Leave blank for default label."));
  ui->opXLabelLine->setWhatsThis(tr("Enter the x-axis label for the plot. Leave the entry blank to "
	  "have the label created automatically."));
  // y-axis label (left)
  ui->opYLabelLeftLine->setToolTip(tr("Specify the left y-axis label. Leave blank for default."));
  ui->opYLabelLeftLine->setStatusTip(tr("Specify the left y-axis label. Leave blank for default label."));
  ui->opYLabelLeftLine->setWhatsThis(tr("Enter the left y-axis label for the plot. Leave the entry blank to "
	  "have the label created automatically."));

  // y-axis label (right)	
  //ui->opYLabelRightLine->setToolTip(tr("Right Y Axis Label"));
  //ui->opYLabelRightLine->setStatusTip(tr("Specify the right y-axis label"));
  //ui->opYLabelRightLine->setWhatsThis(tr("Enter the right y-axis label for the plot."));
  // Plot type	
  ui->opTypeCombo->setToolTip(tr("Plot Type"));
  ui->opTypeCombo->setStatusTip(tr("Choose plot type"));
  ui->opTypeCombo->setWhatsThis(tr("Choose from among the available plot types: "
	  "<ul>"
	  "<li> Boundaries"
	  "<li> Power"
	  "<li> Treatment Effect"
	  "<li> Conditional Power"
	  "<li> Spending Function"
	  "<li> Expected Sample Size"
	  "<li> B-Values"
	  "</ul>"));

// Plot Editor	
  // Line 1 color	
  ui->opLine1ColorCombo->setToolTip(tr("Line 1 Color"));
  ui->opLine1ColorCombo->setStatusTip(tr("Choose line 1 color"));
  ui->opLine1ColorCombo->setWhatsThis(tr("Choose the color for the first line plot."));

  //Line 1 type	
  ui->opLine1TypeCombo->setToolTip(tr("Line 1 Type"));
  ui->opLine1TypeCombo->setStatusTip(tr("Choose line 1 type"));
  ui->opLine1TypeCombo->setWhatsThis(tr("Choose the line type for the first line plot"));

  // Line 1 width	
  ui->opLine1WidthSpin->setToolTip(tr("Line 1 Width"));
  ui->opLine1WidthSpin->setStatusTip(tr("Choose line 1 width"));
  ui->opLine1WidthSpin->setWhatsThis(tr("Choose the line width for the first line plot"));

  // Line 2 color	
  ui->opLine2ColorCombo->setToolTip(tr("Line 2 Color"));
  ui->opLine2ColorCombo->setStatusTip(tr("Choose line 2 color"));
  ui->opLine2ColorCombo->setWhatsThis(tr("Choose the color for the second line plot."));

  //Line 2 type	
  ui->opLine2TypeCombo->setToolTip(tr("Line 2 Type"));
  ui->opLine2TypeCombo->setStatusTip(tr("Choose line 2 type"));
  ui->opLine2TypeCombo->setWhatsThis(tr("Choose the line type for the second line plot"));

  // Line 2 width	
  ui->opLine2WidthSpin->setToolTip(tr("Line 2 Width"));
  ui->opLine2WidthSpin->setStatusTip(tr("Choose line 2 width"));
  ui->opLine2WidthSpin->setWhatsThis(tr("Choose the line width for the second line plot"));

  //Low/High quality graphics selector	
  ui->opPlotRenderCombo->setToolTip(tr("Plot Rendering"));
  ui->opPlotRenderCombo->setStatusTip(tr("Choose plot rendering method"));
  ui->opPlotRenderCombo->setWhatsThis(tr("Choose Basic to use the basic rendering method, or High-Quality to use ggplot2 rendering."));

  // Line 1 symbol digits	
  ui->opLine1SymDigitsSpin->setToolTip(tr("Display Digits"));
  ui->opLine1SymDigitsSpin->setStatusTip(tr("Specify number of digits to display"));
  ui->opLine1SymDigitsSpin->setWhatsThis(tr("Choose the number of digits to be displayed."));
  // Line 2 symbol digits
  ui->opLine2SymDigitsSpin->setToolTip(tr("Display Digits"));
  ui->opLine2SymDigitsSpin->setStatusTip(tr("Specify number of digits to display"));
  ui->opLine2SymDigitsSpin->setWhatsThis(tr("Choose the number of digits to be displayed."));
  
 
  ui->outPlot->setToolTip(tr("Plot Output"));

 // Main toolbar

  // Save toolbar button
   ui->toolbarActionSaveDesign->setToolTip(tr("Save design(s) to file"));
   ui->toolbarActionSaveDesign->setStatusTip(tr("Save design(s) to file"));
   ui->toolbarActionSaveDesign->setWhatsThis(tr("Save the current set of designs to a file "
	   "(in gsDesign format, with a .gsd extension)."));

  // Load toolbar button
   ui->toolbarActionLoadDesign->setToolTip(tr("Load design(s) from file"));
   ui->toolbarActionLoadDesign->setStatusTip(tr("Load design(s) from a .gds file"));
   ui->toolbarActionLoadDesign->setWhatsThis(tr("Load design(s) from a gsDesign (.gsd) format file"));

  // New toolbar button
    ui->toolbarActionNewDesign->setToolTip(tr("Add new design"));
	ui->toolbarActionNewDesign->setStatusTip(tr("Add new design"));
	ui->toolbarActionNewDesign->setWhatsThis(tr("Begin a new design"));

  // Delete toolbar button
	ui->toolbarActionDeleteDesign->setToolTip(tr("Delete current design"));
	ui->toolbarActionDeleteDesign->setStatusTip(tr("Delete current design"));
	ui->toolbarActionDeleteDesign->setWhatsThis(tr("Delete the current design"));

  // Default toolbar button
	ui->toolbarActionDefaultDesign->setToolTip(tr("Reset design to default"));
	ui->toolbarActionDefaultDesign->setStatusTip(tr("Reset current design to default"));
	ui->toolbarActionDefaultDesign->setWhatsThis(tr("Set all parameters in the current design to default values"));

  // Export toolbar button
  ui->toolbarActionExportDesign->setToolTip(tr("Export design to file"));
  ui->toolbarActionExportDesign->setStatusTip(tr("Export design to R script file"));
  ui->toolbarActionExportDesign->setWhatsThis(tr("Export the current design as an R script"));

  // Run toolbar button
  ui->toolbarActionRunDesign->setToolTip(tr("Execute design in R"));
  ui->toolbarActionRunDesign->setStatusTip(tr("Execute design in R and display results"));
  ui->toolbarActionRunDesign->setWhatsThis(tr("Send the current design to R as a call to gsDesign and display results in the Output window"));

  // Edit plot/design toolbar button
  ui->toolbarActionEditPlot->setToolTip(tr("Toggle between editing current design or current plot"));
  ui->toolbarActionEditPlot->setStatusTip(tr("Toggle between editing current design or current plot parameters"));
  ui->toolbarActionEditPlot->setWhatsThis(tr("Toggle between editing current design parameters or "
	  "current plot parameters in the left pane."));

   // Export plot toolbar button
  ui->toolbarActionExportPlot->setToolTip(tr("Export current plot to file"));
  ui->toolbarActionExportPlot->setStatusTip(tr("Export current plot to BMP, JPEG, PNG, TIFF, or PDF file"));
  ui->toolbarActionExportPlot->setWhatsThis(tr("Export current plot to BMP, JPEG, PNG, TIFF, or PDF file"));

  // Help toolbar button
  ui->toolbarActionContextHelp->setToolTip(tr("What's This? cursor"));
  ui->toolbarActionContextHelp->setStatusTip(tr("What's This? cursor"));
  ui->toolbarActionContextHelp->setWhatsThis(tr("What's This? cursor"));

  // New design name
  ui->dnNameCombo->setToolTip(tr("Press Enter/Return to set changes to design name."));
  ui->dnNameCombo->setStatusTip(tr("Press Enter/Return to set changes to design name."));
  ui->dnNameCombo->setWhatsThis(tr("Press Enter/Return to set changes to design name."));

  ui->dnDescCombo->setToolTip(tr("Press Enter/Return to set changes to design description."));
  ui->dnDescCombo->setStatusTip(tr("Press Enter/Return to set changes to design description."));
  ui->dnDescCombo->setWhatsThis(tr("Press Enter/Return to set changes to design description."));
   
  ui->dnModeCombo->setToolTip(tr("Choose the active design."));
  ui->dnModeCombo->setStatusTip(tr("Choose the active design."));
  ui->dnModeCombo->setWhatsThis(tr("Choose the active design."));
}