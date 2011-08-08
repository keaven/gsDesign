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
#include "math.h"
#include "GsRList.h"

// #if defined( __MINGW32__ )
// gsDesign::gsDesign( QWidget *parent ) : ui( new Ui::gsDesign )
// {
	// printf("Can we make it here...\n");
	// ui->setupUi(this);
// #else
gsDesign::gsDesign(QWidget *parent) :
        QMainWindow(parent),
        ui(new Ui::gsDesign)
{
	printf("Can we make it here...\n");
	ui->setupUi(this);
// #endif
	printf("Maybe here...\n");

    // install event filters
    ui->dnNameCombo->installEventFilter(this);
	printf("Now, maybe here...\n");
    ui->dnDescCombo->installEventFilter(this);

    // block signals until initialization is over
    ui->gsDesignMainWidget->blockSignals(true);

    // Add whatsThis? action to help toolbar
    QAction *whatsThisAction = QWhatsThis::createAction(parent);
    ui->helpToolbar->addAction(whatsThisAction);
    whatsThisAction->setIcon(QIcon(":/toolbar/images/toolbar/help.png"));
    whatsThisAction->setIconText("Help");

    // member variables
    currentDesignFile = "";
    currentWorkingDirectory = QDir::toNativeSeparators(QDir::homePath());
//    plotFilePath = "/var/folders/eh/eh16VtaMEYWiK8NbVWyN8U+++TI/-Tmp-//RtmpQuy1nl/gsDesignPlot.png";
    plotFilePath = "c:/gsDesignPlot.png";
    gsDesignExplorerVersion = "1.0-2";
    designRunOnce = false;

    ////
    // Main Application
    ////

    setWindowTitle("gsDesignExplorer " + gsDesignExplorerVersion);

    ////
    // Toolbars and Menus
    ////

    ui->fileToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    ui->designToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    ui->outputToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    ui->helpToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);

    ////
    // statusTip
    ////

    setStatusTips();

    setHelpTips();

    // design mode
    ui->dnModeCombo->setCurrentIndex(0); // design

    ////
    // Tabs
    ////

    ui->sampleSizeTab->setCurrentIndex(0); // user input
    ui->spendingFunctionTab->setCurrentIndex(1); // spending function upper
    ui->designTab->setCurrentIndex(0); // error, power and timing
    ui->outputTab->setCurrentIndex(0); // text
    ui->sfl2PTab->setCurrentIndex(0); // points
    ui->sfu2PTab->setCurrentIndex(0); // points

    ////
    // ui->sflParamToolBox
    //

    ui->sflParamToolBox->setCurrentIndex(1); // 1-parameter

    ////
    // Design Navigator
    ////

    ui->dnNameCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
    ui->dnDescCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
    ui->dnNameCombo->blockSignals(true);
    ui->dnDescCombo->blockSignals(true);
    ui->dnNameCombo->setItemText(0, "Design1");
    ui->dnDescCombo->setItemText(0, "Design1 description ...");
    ui->dnNameCombo->blockSignals(false);
    ui->dnDescCombo->blockSignals(false);

    ////
    // Error, power and timing
    ////

    ui->eptSpacingCombo->setCurrentIndex(0);  // equal spacing
    ui->eptIntervalsSpin->setValue(2);  // number of intervals
    setTimingTableRows();

    // power has to be greater than the Type I error
    setPowerMinimum();

    // sample size user input
    ui->ssUserFixedSpin->setMinimum(1);
    ui->ssUserFixedSpin->setMaximum(1000000);
    ui->ssUserFixedSpin->setValue(1);

    // sample size binomial
    ui->ssBinFixedSpin->setEnabled(false);
    ui->ssBinFixedSpin->setReadOnly(true);
    ui->ssBinFixedSpin->setMinimum(0);
    ui->ssBinFixedSpin->setMaximum(1000000);

    ui->ssBinSupCombo->setCurrentIndex(0);
//    ui->ssBinDeltaDSpin->setDecimals(4);
    ui->ssBinDeltaDSpin->setValue(0.0);

    ui->ssBinRatioDSpin->setMinValue(0.001);
    ui->ssBinRatioDSpin->setMaxValue(1000.0);
    ui->ssBinRatioDSpin->setStep(0.5);;

    ui->ssBinControlDSpin->setMinValue(0.0001);
    ui->ssBinControlDSpin->setMaxValue(0.9999);
    ui->ssBinExpDSpin->setMinValue(0.0001);
    ui->ssBinExpDSpin->setMaxValue(0.9999);

    setDeltaRange();
    ui->ssBinDeltaDSpin->setStep(0.1);

//    ui->ssBinControlDSpin->setDecimals(5);
//    ui->ssBinExpDSpin->setDecimals(5);
//    ui->ssBinRatioDSpin->setDecimals(5);
//    ui->ssBinDeltaDSpin->setDecimals(5);

    // sample size time-to-event

    ui->ssTEFixedSpin->setEnabled(false);
    ui->ssTEFixedSpin->setReadOnly(true);
    ui->ssTEFixedEventSpin->setEnabled(false);
    ui->ssTEFixedEventSpin->setReadOnly(true);
    ui->ssTEFixedSpin->setMinimum(0);
    ui->ssTEFixedSpin->setMaximum(1000000);
    ui->ssTEFixedEventSpin->setMinimum(0);
    ui->ssTEFixedEventSpin->setMaximum(1000000);

    // if minimum is set to anything other than 0, that value gets added to any increment
    // at button click
    ui->ssTECtrlDSpin->setMinValue(0.000);
    ui->ssTEExpDSpin->setMinValue(0.000);
    ui->ssTEDropoutDSpin->setMinValue(0.000);

    ui->ssTECtrlDSpin->setMaxValue(1e6);
    ui->ssTEExpDSpin->setMaxValue(1e6);
    ui->ssTEDropoutDSpin->setMaxValue(1e6);

    ui->ssTEAccrualDSpin->setMinValue(0.0001);
    ui->ssTEFollowDSpin->setMinValue(0.0001);
    ui->ssTERatioDSpin->setMinValue(0.0001);

    ui->ssTEGammaDSpin->setMinValue(0.0001);

//    ui->ssTECtrlDSpin->setDecimals(16);
//    ui->ssTEExpDSpin->setDecimals(16);
//    ui->ssTEDropoutDSpin->setDecimals(16);

    ui->ssTECtrlDSpin->setValue( log(2.0) / 6.0 );
    ui->ssTEExpDSpin->setValue( log(2.0) / 10.0 );
    ui->ssTEDropoutDSpin->setValue( log(2.0) / 12.0 );

    controlER = ui->ssTECtrlDSpin->value();
    experimentalER = ui->ssTEExpDSpin->value();
    dropoutER = ui->ssTEDropoutDSpin->value();

    ui->ssTEAccrualDSpin->setValue(18.0);
    ui->ssTEFollowDSpin->setValue(12.0);
    ui->ssTERatioDSpin->setValue(1.0);

//    ui->ssTECtrlDSpin->setDecimals(5);
//    ui->ssTEExpDSpin->setDecimals(5);
//    ui->ssTEDropoutDSpin->setDecimals(5);
//    ui->ssTEAccrualDSpin->setDecimals(4);
//    ui->ssTEFollowDSpin->setDecimals(4);
//    ui->ssTERatioDSpin->setDecimals(4);
//    ui->ssTEGammaDSpin->setDecimals(4);

    setTimeToEventSuffixes();

    ui->ssTESwitchCombo->setCurrentIndex(1); // median time specification

    ui->modeStack->setCurrentIndex(0);
    lastModeStack = 0;
    plotSwitch = false;

    // initialize samples size:time to event:accrual visibility
    on_ssTEAccrualCombo_currentIndexChanged();

    // lower spending function: 1-parameter & Hwang-Shih-DeCani
    ui->sfuParamToolBox->setCurrentIndex(1);
    ui->sfl1PCombo->setCurrentIndex(0);
    initialize1ParamSpending(ui->sfl1PCombo, ui->sfl1PDSpin, gsDesign::LowerSpending);

    // upper spending function: 1-parameter & Hwang-Shih-DeCani
    ui->sfuParamToolBox->setCurrentIndex(1);
    ui->sfu1PCombo->setCurrentIndex(0);
    initialize1ParamSpending(ui->sfu1PCombo, ui->sfu1PDSpin, gsDesign::UpperSpending);

    // lower spending 2- and 3-parameter initial X & Y point values
    ui->sfl2PPt1XDSpin->setValue(0.25);
    ui->sfl2PPt2XDSpin->setValue(0.5);
    ui->sfl2PPt1YDSpin->setValue(0.1);
    ui->sfl2PPt2YDSpin->setValue(0.27);

    ui->sfl3PPt1XDSpin->setValue(0.25);
    ui->sfl3PPt2XDSpin->setValue(0.5);
    ui->sfl3PPt1YDSpin->setValue(0.1);
    ui->sfl3PPt2YDSpin->setValue(0.27);

    // upper spending 2- and 3-parameter initial X & Y point values
    ui->sfu2PPt1XDSpin->setValue(0.25);
    ui->sfu2PPt2XDSpin->setValue(0.5);
    ui->sfu2PPt1YDSpin->setValue(0.03);
    ui->sfu2PPt2YDSpin->setValue(0.12);

    ui->sfu3PPt1XDSpin->setValue(0.25);
    ui->sfu3PPt2XDSpin->setValue(0.5);
    ui->sfu3PPt1YDSpin->setValue(0.03);
    ui->sfu3PPt2YDSpin->setValue(0.12);

    // lower spending 2- and 3-parameter X & Y decimals
//    int spinDecimals = 4;
//    ui->sfl2PPt1XDSpin->setDecimals(spinDecimals);
//    ui->sfl2PPt2XDSpin->setDecimals(spinDecimals);
//    ui->sfl2PPt1YDSpin->setDecimals(spinDecimals);
//    ui->sfl2PPt2YDSpin->setDecimals(spinDecimals);
//
//    ui->sfl3PPt1XDSpin->setDecimals(spinDecimals);
//    ui->sfl3PPt2XDSpin->setDecimals(spinDecimals);
//    ui->sfl3PPt1YDSpin->setDecimals(spinDecimals);
//    ui->sfl3PPt2YDSpin->setDecimals(spinDecimals);
//
//    // upper spending 2- and 3-parameter initial X & Y decimals
//    ui->sfu2PPt1XDSpin->setDecimals(spinDecimals);
//    ui->sfu2PPt2XDSpin->setDecimals(spinDecimals);
//    ui->sfu2PPt1YDSpin->setDecimals(spinDecimals);
//    ui->sfu2PPt2YDSpin->setDecimals(spinDecimals);
//
//    ui->sfu3PPt1XDSpin->setDecimals(spinDecimals);
//    ui->sfu3PPt2XDSpin->setDecimals(spinDecimals);
//    ui->sfu3PPt1YDSpin->setDecimals(spinDecimals);
//    ui->sfu3PPt2YDSpin->setDecimals(spinDecimals);

    // lower spending 2- and 3-parameter X & Y singleStep size
    double pointStep = 0.1;
    ui->sfl2PPt1XDSpin->setStep(pointStep);
    ui->sfl2PPt2XDSpin->setStep(pointStep);
    ui->sfl2PPt1YDSpin->setStep(pointStep);
    ui->sfl2PPt2YDSpin->setStep(pointStep);

    ui->sfl3PPt1XDSpin->setStep(pointStep);
    ui->sfl3PPt2XDSpin->setStep(pointStep);
    ui->sfl3PPt1YDSpin->setStep(pointStep);
    ui->sfl3PPt2YDSpin->setStep(pointStep);

    // upper spending 2- and 3-parameter X & Y singleStep size
    ui->sfu2PPt1XDSpin->setStep(pointStep);
    ui->sfu2PPt2XDSpin->setStep(pointStep);
    ui->sfu2PPt1YDSpin->setStep(pointStep);
    ui->sfu2PPt2YDSpin->setStep(pointStep);

    ui->sfu3PPt1XDSpin->setStep(pointStep);
    ui->sfu3PPt2XDSpin->setStep(pointStep);
    ui->sfu3PPt1YDSpin->setStep(pointStep);
    ui->sfu3PPt2YDSpin->setStep(pointStep);

    // lower and upper spending 3-parameter degrees of freedom
    ui->sfl3PPtsDfDSpin->setValue(2.0);
    ui->sfu3PPtsDfDSpin->setValue(3.0);
    ui->sfl3PLMDfDSpin->setValue(2.0);
    ui->sfu3PLMDfDSpin->setValue(3.0);

    // lower and upper spending 2- and 3-parameter slope
    ui->sfl2PLMSlpDSpin->setMinValue(0.001);
    ui->sfu2PLMSlpDSpin->setMinValue(0.001);
    ui->sfl3PLMSlpDSpin->setMinValue(0.001);
    ui->sfu3PLMSlpDSpin->setMinValue(0.001);

    // lower spending piecewise linear: radio, spinBox, and table
    ui->sflPieceUseInterimRadio->setChecked(false);
    ui->sflPiecePtsSpin->setValue(2);

    ui->sflPieceTableX->blockSignals(true);
    ui->sflPieceTableY->blockSignals(true);

    QTableWidgetItem *sflItemX1 = new QTableWidgetItem(tr("0.25"));
    sflItemX1->setTextAlignment(Qt::AlignRight);
    ui->sflPieceTableX->setItem(0,0,sflItemX1);

    QTableWidgetItem *sflItemX2 = new QTableWidgetItem(tr("0.5"));
    sflItemX2->setTextAlignment(Qt::AlignRight);
    ui->sflPieceTableX->setItem(1,0,sflItemX2);

    QTableWidgetItem *sflItemY1 = new QTableWidgetItem(tr("0.1"));
    sflItemY1->setTextAlignment(Qt::AlignRight);
    ui->sflPieceTableY->setItem(0,0,sflItemY1);

    QTableWidgetItem *sflItemY2 = new QTableWidgetItem(tr("0.27"));
    sflItemY2->setTextAlignment(Qt::AlignRight);
    ui->sflPieceTableY->setItem(1,0,sflItemY2);

    ui->sflPieceTableX->blockSignals(false);
    ui->sflPieceTableY->blockSignals(false);

    // upper spending piecewise linear: radio, spinBox, and table
    ui->sfuPieceUseInterimRadio->setChecked(false);
    ui->sfuPiecePtsSpin->setValue(2);

    ui->sfuPieceTableX->blockSignals(true);
    ui->sfuPieceTableY->blockSignals(true);

    QTableWidgetItem *sfuItemX1 = new QTableWidgetItem(tr("0.25"));
    sfuItemX1->setTextAlignment(Qt::AlignRight);
    ui->sfuPieceTableX->setItem(0,0,sfuItemX1);

    QTableWidgetItem *sfuItemX2 = new QTableWidgetItem(tr("0.5"));
    sfuItemX2->setTextAlignment(Qt::AlignRight);
    ui->sfuPieceTableX->setItem(1,0,sfuItemX2);

    QTableWidgetItem *sfuItemY1 = new QTableWidgetItem(tr("0.1"));
    sfuItemY1->setTextAlignment(Qt::AlignRight);
    ui->sfuPieceTableY->setItem(0,0,sfuItemY1);

    QTableWidgetItem *sfuItemY2 = new QTableWidgetItem(tr("0.27"));
    sfuItemY2->setTextAlignment(Qt::AlignRight);
    ui->sfuPieceTableY->setItem(1,0,sfuItemY2);

    ui->sfuPieceTableX->blockSignals(false);
    ui->sfuPieceTableY->blockSignals(false);

    // lower spending slope and intercept
    ui->sfl2PLMIntDSpin->setMinValue(-1e6);
    ui->sfl2PLMIntDSpin->setMaxValue(1e6);
    ui->sfl2PLMSlpDSpin->setValue(0.68);
    ui->sfl2PLMIntDSpin->setValue(-0.07);

    ui->sfl3PLMIntDSpin->setMinValue(-1e6);
    ui->sfl3PLMIntDSpin->setMaxValue(1e6);
    ui->sfl3PLMSlpDSpin->setValue(0.68);
    ui->sfl3PLMIntDSpin->setValue(-0.07);

    ui->sfu2PLMIntDSpin->setMinValue(-1e6);
    ui->sfu2PLMIntDSpin->setMaxValue(1e6);
    ui->sfu2PLMSlpDSpin->setValue(0.68);
    ui->sfu2PLMIntDSpin->setValue(-0.07);

    ui->sfu3PLMIntDSpin->setMinValue(-1e6);
    ui->sfu3PLMIntDSpin->setMaxValue(1e6);
    ui->sfu3PLMSlpDSpin->setValue(0.68);
    ui->sfu3PLMIntDSpin->setValue(-0.07);

    // 2-parameter distribution function
    ui->sfl2PFunCombo->setCurrentIndex(4);
    ui->sfu2PFunCombo->setCurrentIndex(4);

    // upper an lower spending 2- ad 3-parameter piecewise linear
    ui->sflPieceTableX->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    ui->sflPieceTableY->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    ui->sfuPieceTableX->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    ui->sfuPieceTableY->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

    // upper and lower spending piecewise linear table width
    ui->sflPieceTableX->horizontalHeader()->setFixedWidth(120);
    ui->sflPieceTableY->horizontalHeader()->setFixedWidth(120);
    ui->sfuPieceTableX->horizontalHeader()->setFixedWidth(120);
    ui->sfuPieceTableY->horizontalHeader()->setFixedWidth(120);

    ////
    // ALIGNMENT
    ////

    Qt::AlignmentFlag hcenter = Qt::AlignRight;
    Qt::AlignmentFlag vcenter = Qt::AlignVCenter;

    // QDoubleSpinBox
//    foreach (QwtCounter *dspin, ui->gsDesignMainWidget->findChildren<QwtCounter*>()) {
//        dspin->setAlignment(hcenter | vcenter);
//    }

    // QSpinBox
    foreach (QSpinBox *spin, ui->gsDesignMainWidget->findChildren<QSpinBox*>()) {
        spin->setAlignment(hcenter | vcenter);
    }

    // QLabel
    foreach (QLabel *label, ui->gsDesignMainWidget->findChildren<QLabel*>()) {
        label->setAlignment(hcenter | vcenter);
    }

    // outplot message
    ui->outPlot->setAlignment(Qt::AlignHCenter | vcenter);
    ui->outPlot->setWordWrap(true);

    // Connect the two plot rendering slots
    QObject::connect( ui->opPlotRenderCombo , SIGNAL( currentIndexChanged( int ) ) ,
        ui->outputPlotRenderCombo , SLOT( setCurrentIndex( int ) ) );
    QObject::connect( ui->outputPlotRenderCombo , SIGNAL( currentIndexChanged( int ) ) ,
        ui->opPlotRenderCombo , SLOT( setCurrentIndex( int ) ) );
    QObject::connect( ui->opTypeCombo , SIGNAL( currentIndexChanged( int ) ) ,
        ui->outputPlotTypeCombo , SLOT( setCurrentIndex( int ) ) );
    QObject::connect( ui->outputPlotTypeCombo , SIGNAL( currentIndexChanged( int ) ) ,
        ui->opTypeCombo , SLOT( setCurrentIndex( int ) ) );

    // welcome message
    ui->otEdit->setText("Welcome to gsDesign Explorer");

    ////
    // PLOT
    ////

    ui->opTypeCombo->setCurrentIndex(0);
    setPlotDefaults();
    updateOutputPlotMap(setMap);
    ui->opPlotRenderCombo->setCurrentIndex(0); // basic rendering

    ////
    // ANALYSIS MODE
    ////

    ui->anlSampleSizeTable->clear();
    ui->anlMaxSampleSizeSpin->setValue(1);
    QStringList anlSampleSizeTableHeader;
    anlSampleSizeTableHeader << "n at analyses";
    ui->anlSampleSizeTable->setHorizontalHeaderLabels(anlSampleSizeTableHeader);

    QTableWidgetItem *itemSS1 = new QTableWidgetItem();
    itemSS1->setData(Qt::DisplayRole, (double) -1.0);
    itemSS1->setTextAlignment(Qt::AlignRight);
    ui->anlSampleSizeTable->setItem(0,0,itemSS1);

    formatTable(ui->anlSampleSizeTable, (double) -1.0, (double) 1e6);

    ui->anlMaxnIPlanDSpin->setMinValue(1.0);
    ui->anlMaxnIPlanDSpin->setMaxValue((double) 1e6);

    ui->anlLockTimesRadio->setChecked(false);

    ////
    // designList
    ////

    designList.clear();
    newDesigns = 1;
    designList << updateDesignMap();
    setDeleteDesignVisibility();

    ////
    // defaultDesign
    ////

    defaultDesign = designList[0];

    // unblock signals
    ui->gsDesignMainWidget->blockSignals(false);
    GsRList::m_bAllowRunDesign = true;

    // Connect the two slider slots
    QObject::connect( ui->eptErrorDSpin , SIGNAL( valueChanged( double ) ) ,
        ui->eptErrorHSlider , SLOT( setValue( double ) ) );
    QObject::connect( ui->eptPowerDSpin , SIGNAL( valueChanged( double ) ) ,
        ui->eptPowerHSlider , SLOT( setValue( double ) ) );

    ui->eptErrorHSlider->setScalePosition( QwtSlider::BottomScale );
    ui->eptErrorHSlider->setRange( 0.0 , 100.0 , 0.1 );
    ui->eptPowerHSlider->setScalePosition( QwtSlider::BottomScale );
    ui->eptPowerHSlider->setRange( 0.0 , 100.0 , 0.5 );
    ui->eptErrorHSlider->setValue( ui->eptErrorDSpin->value() );
    ui->eptPowerHSlider->setValue( ui->eptPowerDSpin->value() );
}

gsDesign::~gsDesign()
{
    delete ui;
}

void gsDesign::changeEvent(QEvent *e)
{
    QMainWindow::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

/////
// TOOLBAR
////


void gsDesign::on_toolbarActionLoadDesign_triggered()
{
    QString fileName="";
    loadFile(fileName);
}

void gsDesign::on_toolbarActionDeleteDesign_triggered()
{
    deleteDesign();
}

void gsDesign::on_toolbarActionNewDesign_triggered()
{
    addNewDesign();
}


/////
// Menu
////

////
// MAIN SCREEN
////


////
// UTILITY
////

void gsDesign::setTimingTableRows()
{
    int nrowOld = ui->eptTimingTable->rowCount();
    int nrowNew = ui->eptIntervalsSpin->value();
    int i;
    QString spacing = ui->eptSpacingCombo->currentText();
    QString valstr;
    QTableWidgetItem *item;
    double val;

    ui->eptIntervalsSpin->blockSignals(true);

    // set number of rows in table
    ui->eptTimingTable->setRowCount(nrowNew);

    if (nrowNew > nrowOld)
    {
        for (i = nrowOld; i < nrowNew; i++)
        {
            item = ui->eptTimingTable->item(i, 0);

            if (!item)
            {
                // obtain previous cell's value
                val = ui->eptTimingTable->item(i - 1, 0)->text().toDouble();
                valstr.setNum((1.0 + val) / 2.0);

                QTableWidgetItem *newItem = new QTableWidgetItem();
                newItem->setData(Qt::DisplayRole, val);
                ui->eptTimingTable->setItem(i, 0, newItem);
                newItem->setTextAlignment(Qt::AlignRight);
            }
        }
    }

    // fill the timing table if spacing is equal
    if (spacing == "Equal")
    {
        fillTimingTable();
    }

    ui->eptIntervalsSpin->blockSignals(false);
}

void gsDesign::setTimingTableEnable()
{
    QString spacing = ui->eptSpacingCombo->currentText();
    bool isSpacingUnequal = (spacing == "Unequal");

    ui->eptTimingTable->setEnabled(isSpacingUnequal);
}

void gsDesign::fillTimingTable()
{
    double val;
    int i;
    int j;
    int nrow = ui->eptTimingTable->rowCount();
    int ncol = ui->eptTimingTable->columnCount();
    double dt = 1.0 / double (nrow + 1);
    QTableWidgetItem *item;

    // validate table entries
    for (j = 0; j < ncol; j++)
    {
        // initialize variables
        val = dt;

        for (i = 0; i < nrow; i++)
        {
            // get tableWidgetItem
            item = ui->eptTimingTable->item(i, j);

            // ensure item is not NULL
            if (!item)
            {
                QTableWidgetItem *newItem = new QTableWidgetItem();
                newItem->setData(Qt::DisplayRole, val);
                ui->eptTimingTable->setItem(i, j, newItem);
                newItem->setTextAlignment(Qt::AlignRight);
            }
            else{
                item->setData(Qt::DisplayRole, val);
                item->setTextAlignment(Qt::AlignRight);
            }

            // increment value
            val += dt;
        }
    }
}

void gsDesign::formatTable(QTableWidget *table, double minimum, double maximum)
{
    double val;
    int i;
    int ival;
    int nrow = table->rowCount();
    QTableWidgetItem *item;
    table->setSortingEnabled(false);

    for (i = 0; i < nrow; i++)
    {
        // obtain tableWidgetItem
        item = table->item(i, 0);

        // ensure item is not NULL, otherwise the application will crash!
        if (!item)
        {
            continue;
        }

        // obtain cell string and convert to double value
        val = item->text().toDouble();

        // set precision
        // note: round() kills the GUI for some reason
        ival = val * 10000;
        val = (double) ival / 10000.0;

        item->setData(Qt::DisplayRole, val);

        // check the low bound
        if (val <= minimum)
        {
            item->setData(Qt::DisplayRole, minimum);
        }

        // check the high bound
        if (val >= maximum)
        {
            item->setData(Qt::DisplayRole, maximum);
        }

        // justification
        item->setTextAlignment(Qt::AlignRight);
    }

    table->sortItems(0, Qt::AscendingOrder);
}

void gsDesign::initialize1ParamSpending(QComboBox *combo, QwtCounter *param, gsDesign::Spending spending)
{
    // Initialize 1-parameter spending function param argument range and value
    //
    // e.g., initialize1ParamSpending(ui->sfl1PCombo, ui->sfl1PDSpin, gsDesign::Spending LowerSpending)

    double DBLMAX = 1000000.0;
    QString type = combo->currentText();

    switch(spending)
    {

    case LowerSpending:

        if (type == "Hwang-Shih-DeCani")
        {
            param->setMinValue(-40.0);
            param->setMaxValue(40.0);
            param->setValue(-1.0);
        }

        if (type == "Power")
        {
            param->setMinValue(0.0001);
            param->setMaxValue(DBLMAX);
            param->setValue(2.0);
        }

        if (type == "Exponential")
        {
            param->setMinValue(0.0001);
            param->setMaxValue(DBLMAX);
            param->setValue(0.4);
        }

        break;

    case UpperSpending:

        if (type == "Hwang-Shih-DeCani")
        {
            param->setMinValue(-40.0);
            param->setMaxValue(40.0);
            param->setValue(-8.0);
        }

        if (type == "Power")
        {
            param->setMinValue(0.0001);
            param->setMaxValue(DBLMAX);
            param->setValue(3.0);
        }

        if (type == "Exponential")
        {
            param->setMinValue(0.0001);
            param->setMaxValue(DBLMAX);
            param->setValue(0.75);
        }

        break;
    }
}

////
// FILE
////

void gsDesign::setCurrentFile(const QString &fileName)
{
    currentDesignFile = fileName;
    setWindowModified(false);
    QString shownName = tr("Untitled");
    if (!currentDesignFile.isEmpty()) {
        shownName = strippedName(currentDesignFile);
        setWindowTitle(tr("%1 : %2[*]").arg("gsDesign File").arg(shownName));
    }

}

QString gsDesign::strippedName(const QString &fullFileName)
{
    return QFileInfo(fullFileName).fileName();
}

bool gsDesign::save()
{
    if (currentDesignFile.isEmpty()) {
        return saveAs();
    } else {
        return saveFile(currentDesignFile);
    }
}

bool gsDesign::saveFile(const QString &fileName)
{
    if (!writeFile(fileName)) {
        statusBar()->showMessage(tr("Saving canceled"), 2000);
        return false;
    }

    setCurrentFile(fileName);
    statusBar()->showMessage("File " + strippedName(fileName) + " saved", 2000);
    return true;
}

bool gsDesign::saveAs()
{
    QString defaultFileName = currentWorkingDirectory.absolutePath() + "/" + ui->dnNameCombo->currentText() + ".gsd";

    QString fileName = QFileDialog::getSaveFileName(this,
                                                    tr("Save the current design(s) to file"),
                                                    defaultFileName,
                                                    tr("gsDesign files (*.gsd);;All Files (*)"));

    if (fileName.isEmpty())
        return false;
    return saveFile(fileName);
}

bool gsDesign::writeFile(const QString &fileName)
{
    if (fileName.isEmpty())
        return false;
    else
    {
        QFile file(fileName);

        if (!file.open(QIODevice::WriteOnly)) {
            QMessageBox::information(this, tr("Unable to open file"),
                                     file.errorString());
            return false;
        }

        QDataStream out(&file);
        out.setVersion(QDataStream::Qt_4_5);
        out << designList;

        return true;
    }
}

void gsDesign::loadFile(QString &fileName)
{
    // load a file containing one or more designs
    if (fileName.isEmpty()){

        fileName = QFileDialog::getOpenFileName(this,
                                                tr("Open design(s) file"),
                                                currentWorkingDirectory.absolutePath(),
                                                tr("gsDesign File (*.gsd);;All Files (*)"));
    }

    if (fileName.isEmpty())
        return;

    QFile file(fileName);

    if (!file.open(QIODevice::ReadOnly)) {
        QMessageBox::information(this, tr("Unable to open file"),
                                 file.errorString());
        return;
    }

    QDataStream in(&file);
    in.setVersion(QDataStream::Qt_4_5);
    designList.empty();   // empty existing design list
    in >> designList;

    QString str, name, desc;

    str = "File : " + fileName + "\n";
    str += "Designs loaded : " + QString::number(designList.length()) + "\n\n";

    ui->outputTab->setCurrentIndex(0);

    // initialize design-related widgets and variables
    newDesigns = designList.length();
    ui->dnNameCombo->blockSignals(true);
    ui->dnDescCombo->blockSignals(true);
    ui->dnNameCombo->lineEdit()->blockSignals(true);
    ui->dnDescCombo->lineEdit()->blockSignals(true);

    ui->dnNameCombo->clear();
    ui->dnDescCombo->clear();
    ui->dnNameCombo->setInsertPolicy(QComboBox::InsertAtBottom);
    ui->dnDescCombo->setInsertPolicy(QComboBox::InsertAtBottom);

    for (int i = 0; i < designList.length(); i++)
    {
        name = designList[i].value("dnNameCombo.string");
        desc = designList[i].value("dnDescCombo.string");

        str += "Name : " + name + "\n";
        str += "Description : " + desc + "\n\n";

        ui->dnNameCombo->addItem(name);
        ui->dnDescCombo->addItem(desc);
    }

    ui->dnNameCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
    ui->dnDescCombo->setInsertPolicy(QComboBox::InsertAtCurrent);

    ui->dnNameCombo->setCurrentIndex(0);
    ui->dnDescCombo->setCurrentIndex(0);

    ui->dnNameCombo->blockSignals(false);
    ui->dnDescCombo->blockSignals(false);
    ui->dnNameCombo->lineEdit()->blockSignals(false);
    ui->dnDescCombo->lineEdit()->blockSignals(false);

    // now synchronize widgets with current (first) design
    loadDesign();
    setCurrentFile(fileName);
    statusBar()->showMessage("File " + fileName + " loaded", 2000);
    ui->outputTab->setCurrentIndex(0);
    ui->otEdit->setText(str);
}

////
// About
////

void gsDesign::about()
{
    QMessageBox::about(this, tr("About gsDesignExplorer"),
                       "<h2>gsDesignExplorer " + gsDesignExplorerVersion + "</h2>"
                       "<p><a href=\"http://www.merck.com/mrl/\">Merck Research Laboratories</a>"
                       "<p><a href=\"http://www.revolution-computing.com\">REvolution Computing Inc.</a>"
                       "<p><a href=\"http://gsdesign.r-forge.r-project.org/\">R-Forge</a>"
                       "<p>gsDesignExplorer is both an R package and a "
                       "collaborative project for the development "
                       "of a graphical user interface to gsDesign: "
                       "an R package intended to provide a flexible "
                       "set of tools for designing and analyzing "
                       "group sequential trials."
                       "<p><p>Copyright &copy; 2009 Merck Research Laboratories and REvolution Computing");
}

void gsDesign::sortTableRows(QTableWidget *table, Qt::SortOrder order)
{
    // For each column in a QTableWidget sort the rows.
    //
    //  table       Pointer to a QTableWidget object
    //  order       Qt::SortOrder enum. Typical choices are Qt::SortAscending | Qt::SortDescending

    int ncol = table->columnCount();

    // sort columns of input table
    for (int j = 0; j < ncol; j++)
    {
        // sort the timing vector (column) in ascending order
        table->sortItems(j, order);
    }
}

void gsDesign::spendingFunctionPiecewiseTableNROWUpdate(
        QRadioButton *useInterimRadio, QSpinBox *nIntervalsSpin, QTableWidget *tableX, QTableWidget *tableY)
{
    // Updates the number of rows of a piecewise linear spending function table and sets the enable
    // property of an associated spinBox: if 'use interims' radio is selected then the spinBox controlling
    // the number of rows is disabled.
    //
    //  useInterimRadio       Pointer to a QRadioButton object. If selected, the number of interims
    //                        spinBox (eptIntervalsSpin) is used to set the number of table rows.
    //                        Otherwise, the nIntervalsSpin object value is used to do so.
    //
    //  nIntervalsSpin        Pointer to a QSpinBox object used to control the number of rows in the
    //                        corresponding table if useInterimRadio is not checked.
    //
    //  table                 Pointer to a QTableWidget object. The number of rows in this table are set.

    int nrow;

    if (useInterimRadio->isChecked())
    {
        nrow = ui->eptIntervalsSpin->value();
        nIntervalsSpin->setEnabled(false);
    }
    else
    {
        nIntervalsSpin->setEnabled(true);
        nrow = nIntervalsSpin->value();
    }

    tableX->setRowCount(nrow);
    tableY->setRowCount(nrow);
}

void gsDesign::getPlotQMapPointer(QString type, QMap<QString, QString> **plot)
{
    if (type == "Boundaries") *plot = &opBoundariesMap;
    if (type == "Power") *plot = &opPowerMap;
    if (type == "Treatment Effect") *plot = &opTreatmentMap;
    if (type == "Conditional Power") *plot = &opConditionalPowerMap;
    if (type == "Spending Function") *plot = &opSpendingMap;
    if (type == "Expected Sample Size") *plot = &opSampleSizeMap;
    if (type == "B-Values") *plot = &opBValuesMap;
}

void gsDesign::updateOutputPlotMap(gsDesign::MapAction action)
{
    QMap<QString, QString> *plot;
    getPlotQMapPointer(ui->opTypeCombo->currentText(), &plot);

    if (plot->isEmpty())
    {
        setPlotDefaults();
        action = setMap;
    }

    if (action == setMap)
    {
        plot->insert("main", ui->opTitleLine->displayText());
        plot->insert("xlab", ui->opXLabelLine->displayText());
        plot->insert("ylabLeft", ui->opYLabelLeftLine->displayText());
        plot->insert("lwd1", ui->opLine1WidthSpin->cleanText());
        plot->insert("col1", QString::number(ui->opLine1ColorCombo->currentIndex()));
        plot->insert("lty1", QString::number(ui->opLine1TypeCombo->currentIndex()));
        plot->insert("lwd2", ui->opLine2WidthSpin->cleanText());
        plot->insert("col2", QString::number(ui->opLine2ColorCombo->currentIndex()));
        plot->insert("lty2", QString::number(ui->opLine2TypeCombo->currentIndex()));
        plot->insert("symDigits1", ui->opLine1SymDigitsSpin->cleanText());
        plot->insert("symDigits2", ui->opLine2SymDigitsSpin->cleanText());
    }

    if (action == getMap)
    {
        blockPlotSignals(true);

        ui->opTitleLine->setText(plot->value("main"));
        ui->opXLabelLine->setText(plot->value("xlab"));
        ui->opYLabelLeftLine->setText(plot->value("ylabLeft"));
        ui->opLine1WidthSpin->setValue(plot->value("lwd1").toInt());
        ui->opLine1ColorCombo->setCurrentIndex(plot->value("col1").toInt());
        ui->opLine1TypeCombo->setCurrentIndex(plot->value("lty1").toInt());
        ui->opLine2WidthSpin->setValue(plot->value("lwd2").toInt());
        ui->opLine2ColorCombo->setCurrentIndex(plot->value("col2").toInt());
        ui->opLine2TypeCombo->setCurrentIndex(plot->value("lty2").toInt());
        ui->opLine1SymDigitsSpin->setValue(plot->value("symDigits1").toInt());
        ui->opLine2SymDigitsSpin->setValue(plot->value("symDigits2").toInt());

        blockPlotSignals(false);
    }

}

void gsDesign::update_opWidgetMapEntry(QString key, QString value)
{
    // General function to add hash key-value pairs to the appropriate plot hash table
    QMap<QString, QString> *plot;
    getPlotQMapPointer(ui->opTypeCombo->currentText(), &plot);
    plot->insert(key, value);
}

void gsDesign::setPlotWidgetsEnable()
{
 //   QString type = ui->opTypeCombo->currentText();
 //   bool enable = (type == "Power" || type == "Spending Function");
 //   ui->opLine2Group->setEnabled(enable);
    ui->opLine2Group->setEnabled(true);
    ui->opLine1Group->setEnabled(true);
    ui->opTitleLine->setEnabled(true);
    ui->opXLabelLine->setEnabled(true);
    ui->opYLabelLeftLine->setEnabled(true);
    ui->opPlotRenderCombo->setEnabled(true);
    ui->opTypeCombo->setEnabled(true);
}

void gsDesign::setPlotDefaults()
{
    QString type = ui->opTypeCombo->currentText();

    setPlotWidgetsEnable();

    ui->opLine1SymDigitsSpin->setMinimum(0);
    ui->opLine1SymDigitsSpin->setMaximum(16);
    ui->opLine2SymDigitsSpin->setMinimum(0);
    ui->opLine2SymDigitsSpin->setMaximum(16);
    ui->opLine1SymDigitsSpin->setValue(2);
    ui->opLine1SymDigitsSpin->setValue(2);
    ui->opLine2SymDigitsSpin->setValue(2);
    ui->opLine2SymDigitsSpin->setValue(2);

    ui->opLine1WidthSpin->setMinimum(1);
    ui->opLine1WidthSpin->setMaximum(3);
    ui->opLine2WidthSpin->setMinimum(1);
    ui->opLine2WidthSpin->setMaximum(3);
    ui->opLine2WidthSpin->setValue(1);


    // we used to set the default text based on plot type but now
    // we set all entries to a blank which forces the gsDesign
    // package to establish the default labels. as the default labels are
    // state depenendent, setting them here is difficult and lessens
    // the adaptibility to future alterations to the gsDesign package
    ui->opTitleLine->setText("");
    ui->opXLabelLine->setText("");
    ui->opYLabelLeftLine->setText("");

    if (type == "Boundaries")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
    }

    if (type == "Power")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
        ui->opLine2ColorCombo->setCurrentIndex(1);
        ui->opLine2WidthSpin->setValue(1);
        ui->opLine2TypeCombo->setCurrentIndex(1);
    }

    if (type == "Treatment Effect")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
    }

    if (type == "Conditional Power")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
    }

    if (type == "Spending Function")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
        ui->opLine2ColorCombo->setCurrentIndex(0);
        ui->opLine2WidthSpin->setValue(1);
        ui->opLine2TypeCombo->setCurrentIndex(1);
    }

    if (type == "Expected Sample Size")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
    }

    if (type == "B-Values")
    {
        ui->opLine1ColorCombo->setCurrentIndex(0);
        ui->opLine1WidthSpin->setValue(1);
        ui->opLine1TypeCombo->setCurrentIndex(0);
    }
}

////
// DESIGN NAVIGATOR
////

void gsDesign::addNewDesign()
{
    QString countStr;
    QString nameStr = "Design";
    int count = ui->dnNameCombo->count();
    int indexDesign = ui->dnNameCombo->currentIndex();

    // block signals
    ui->dnNameCombo->blockSignals(true);
    ui->dnDescCombo->blockSignals(true);

    // use currently selected design to create template for new design
    if (designList.isEmpty())
    {
        designList << updateDesignMap();
    }
    else
    {
        designList << designList[indexDesign];
    }

    // increment number of designs and convert to a string
    countStr.setNum(++newDesigns);

    // create new design name and description
    ui->dnNameCombo->insertItem(count, nameStr + countStr,"");
    ui->dnDescCombo->insertItem(count, nameStr + countStr + " description ...","");
    ui->dnNameCombo->setCurrentIndex(count);
    ui->dnDescCombo->setCurrentIndex(count);
    ui->dnNameCombo->setFocus();
    ui->dnNameCombo->setShown(true);

    // update design name and description in current design hash table
    updateDesignMapQComboBox(ui->dnNameCombo);
    updateDesignMapQComboBox(ui->dnDescCombo);

    // set delete design visibility/enability
    setDeleteDesignVisibility();

    // unblock signals
    ui->dnNameCombo->blockSignals(false);
    ui->dnDescCombo->blockSignals(false);

    //    setPlotDefaults();
    updateOutputPlotMap(getMap);
}

void gsDesign::deleteDesign()
{
    if (designList.length() > 1)
    {
        int current = ui->dnNameCombo->currentIndex();
        ui->dnNameCombo->removeItem(current);
        ui->dnDescCombo->removeItem(current);
        designList.removeAt(current);
    }

    setDeleteDesignVisibility();
}

void gsDesign::dnNameCombo_returnPressed()
{
    QFont f = ui->dnNameCombo->font();
    f.setBold(false);
    ui->dnNameCombo->setFont(f);
    ui->dnDescCombo->setFocus();
    statusBar()->showMessage("Design renamed to" + ui->dnNameCombo->currentText());
}

void gsDesign::dnDescCombo_returnPressed()
{
    QFont f = ui->dnDescCombo->font();
    f.setBold(false);
    ui->dnDescCombo->setFont(f);
    ui->dnNameCombo->setFocus();
    statusBar()->showMessage("Design description reset");
}

bool gsDesign::eventFilter(QObject *o, QEvent *e)
{
    //if ((o == ui->dnNameCombo || o == ui->dnDescCombo) && e->type() == QEvent::FocusOut)
    //{
    //    if (o == ui->dnNameCombo)
    //    {
    //        ui->dnNameCombo->blockSignals(true);
    //        ui->dnNameCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
    //        ui->dnNameCombo->setItemText(0, ui->dnNameCombo->currentText());

    //        QFont f = ui->dnNameCombo->font();
    //        f.setBold(false);
    //        ui->dnNameCombo->lineEdit()->setFont(f);
    //        statusBar()->showMessage("Design renamed to" + ui->dnNameCombo->currentText());
    //        ui->dnNameCombo->blockSignals(false);
    //        updateDesignMapQComboBox(ui->dnNameCombo);
    //    }
    //    else
    //    {
    //        ui->dnDescCombo->blockSignals(true);
    //        ui->dnDescCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
    //        ui->dnDescCombo->setItemText(0, ui->dnDescCombo->currentText());

    //        QFont f = ui->dnDescCombo->font();
    //        f.setBold(false);
    //        ui->dnDescCombo->lineEdit()->setFont(f);
    //        statusBar()->showMessage("Design renamed to" + ui->dnDescCombo->currentText());
    //        ui->dnDescCombo->blockSignals(false);
    //        updateDesignMapQComboBox(ui->dnDescCombo);
    //    }

    //    e->accept();
    //    return QWidget::eventFilter(o, e);
    //}

    if ((o == ui->dnNameCombo || o == ui->dnDescCombo) && e->type() == QEvent::KeyPress)
    {
        QKeyEvent *ke = static_cast<QKeyEvent *>(e);

        if (ke->key() == Qt::Key_Enter || ke->key() == Qt::Key_Return)
        {
            if (o == ui->dnNameCombo)
            {
                QFont f = ui->dnNameCombo->font();
                f.setBold(false);
                ui->dnNameCombo->lineEdit()->setFont(f);
                statusBar()->showMessage("Design renamed to" + ui->dnNameCombo->currentText());
                updateDesignMapQComboBox(ui->dnNameCombo);
            }
            else
            {
                QFont f = ui->dnDescCombo->font();
                f.setBold(false);
                ui->dnDescCombo->lineEdit()->setFont(f);
                statusBar()->showMessage("Design description reset to" + ui->dnDescCombo->currentText());
                updateDesignMapQComboBox(ui->dnDescCombo);
            }

        }
        else
        {
            if (o == ui->dnNameCombo)
            {
                QFont f = ui->dnNameCombo->font();
                if (!f.bold())
                {
                    f.setBold(true);
                    ui->dnNameCombo->lineEdit()->setFont(f);
                    statusBar()->showMessage("Press Enter/Return to set changes to design name or description");
                }
            }
            else
            {
                QFont f = ui->dnDescCombo->font();
                if (!f.bold())
                {
                    f.setBold(true);
                    ui->dnDescCombo->lineEdit()->setFont(f);
                    statusBar()->showMessage("Press Enter/Return to set changes to design name or description");
                }
            }

        }
    }

    return QWidget::eventFilter(o, e);
}

// void gsDesign::on_dnNameCombo_currentIndexChanged( int i )
// {
  // ui->dnDescCombo->setCurrentIndex( i );
// }

void gsDesign::on_dnDescCombo_currentIndexChanged( int i )
{
  ui->dnNameCombo->setCurrentIndex( i );
}

void gsDesign::on_dnNameCombo_editTextChanged(QString string)
{
    ui->dnNameCombo->blockSignals(true);

    // remove special characters
    string.replace(QRegExp("[^a-zA-Z0-9.]"), "");

    // ensure that first character is a character
    string.replace(QRegExp("^[0-9]"), "x");

    if (string.isEmpty())
    {
        string = "x";
    }
    ui->dnNameCombo->setEditText(string);
    ui->dnNameCombo->blockSignals(false);
    updateDesignMapQComboBox(ui->dnNameCombo);
}

void gsDesign::on_dnDescCombo_editTextChanged(QString )
{
    updateDesignMapQComboBox(ui->dnDescCombo);
}

////
// TOOLBOXES
////

void gsDesign::on_sflParamToolBox_currentChanged(int )
{
    updateDesignMapQToolBox(ui->sflParamToolBox);
}

void gsDesign::on_sfuParamToolBox_currentChanged(int )
{
    updateDesignMapQToolBox(ui->sfuParamToolBox);
}

////
// TABS
////

void gsDesign::on_outputTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->outputTab);
}

void gsDesign::on_sfu3PTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->sfu3PTab);
}

void gsDesign::on_sfu2PTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->sfu2PTab);
}

void gsDesign::on_sfl3PTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->sfl3PTab);
}

void gsDesign::on_sfl2PTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->sfl2PTab);
}

void gsDesign::on_spendingFunctionTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->spendingFunctionTab);
}

void gsDesign::on_sampleSizeTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->sampleSizeTab);
}

void gsDesign::on_designTab_currentChanged(int )
{
    updateDesignMapQTabWidget(ui->designTab);
}

////
// ERROR, POWER and TIMING
////

void gsDesign::setPowerMinimum()
{
    double error = ui->eptErrorDSpin->value();
    double delta = 0.0001;

    if (error < (100.0 - delta))
    {
        ui->eptPowerDSpin->setMinValue(error + delta);
    }
    else
    {
        ui->eptPowerDSpin->setMinValue(100.0);
    }
}

void gsDesign::on_eptTimingTable_cellChanged(int, int )
{
    formatTable(ui->eptTimingTable, 0.0001, 0.9999);
    updateDesignMapQTableWidget(ui->eptTimingTable);
}

void gsDesign::on_eptSpacingCombo_currentIndexChanged(int )
{
    setTimingTableRows();
    updateDesignMapQComboBox(ui->eptSpacingCombo);
    updateDesignMapQTableWidget(ui->eptTimingTable);
    ui->eptTimingTable->setEnabled(ui->eptSpacingCombo->currentText() == "Unequal");
}

void gsDesign::on_eptIntervalsSpin_valueChanged(int )
{
    setTimingTableRows();
    updateDesignMapQSpinBox(ui->eptIntervalsSpin);
    updateDesignMapQTableWidget(ui->eptTimingTable);
}

void gsDesign::on_eptPowerDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->eptPowerDSpin);
    ui->eptPowerDSpin->setMinValue(ui->eptErrorDSpin->value() + 0.0001);
}

void gsDesign::on_eptErrorDSpin_valueChanged()
{
    setPowerMinimum();
    updateDesignMapQDoubleSpinBox(ui->eptErrorDSpin);
}

void gsDesign::on_eptPowerHSlider_valueChanged()
{
    ui->eptPowerDSpin->setValue( ui->eptPowerHSlider->value() );
}

void gsDesign::on_eptErrorHSlider_valueChanged()
{
    ui->eptErrorDSpin->setValue( ui->eptErrorHSlider->value() );
}

void gsDesign::on_sflTestCombo_currentIndexChanged(int )
{
    QString lowerBoundTestType = ui->sflTestCombo->currentText();
    bool isTwoSidedFutility = (lowerBoundTestType == "2-sided with futility");

    ui->sflLBTCombo->setEnabled(isTwoSidedFutility);
    ui->sflLBSCombo->setEnabled(isTwoSidedFutility);
    ui->sflParamToolBox->setEnabled(isTwoSidedFutility);

    updateDesignMapQComboBox(ui->sflTestCombo);
}

////
// SAMPLE SIZE
////

void gsDesign::setTimeToEventSuffixes()
{
    QString suffix = "";

//    ui->ssTECtrlDSpin->setSuffix(suffix);
//    ui->ssTEExpDSpin->setSuffix(suffix);
//    ui->ssTEDropoutDSpin->setSuffix(suffix);
//
//    ui->ssTEAccrualDSpin->setSuffix("");
//    ui->ssTEFollowDSpin->setSuffix("");
//    ui->ssTERatioDSpin->setSuffix("");
}

void gsDesign::setDeltaRange()
{
    double pC = ui->ssBinControlDSpin->value();
    double tol = 0.001;
    ui->ssBinDeltaDSpin->setMinValue(-pC + tol);
    ui->ssBinDeltaDSpin->setMaxValue(1 - pC - tol);
}

void gsDesign::on_ssTEFollowDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssTEFollowDSpin);
}

void gsDesign::on_ssTEFixedEventSpin_valueChanged(int )
{
    updateDesignMapQSpinBox(ui->ssTEFixedEventSpin);
}

void gsDesign::on_ssTEFixedSpin_valueChanged(int )
{
    updateDesignMapQSpinBox(ui->ssTEFixedSpin);
}

void gsDesign::on_ssTEGammaDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssTEGammaDSpin);
}

void gsDesign::on_ssTEAccrualCombo_currentIndexChanged()
{
    QString accrual = ui->ssTEAccrualCombo->currentText();
    ui->ssTEGammaDSpin->setEnabled(accrual != "Uniform");
    updateDesignMapQComboBox(ui->ssTEAccrualCombo);
}

void gsDesign::on_ssTEHypCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->ssTEHypCombo);
}

void gsDesign::on_ssTERatioDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssTERatioDSpin);
}

void gsDesign::on_ssTEAccrualDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssTEAccrualDSpin);
}

void gsDesign::on_ssTEDropoutDSpin_valueChanged()
{
    dropoutER = ui->ssTEDropoutDSpin->value();

    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(ui->ssTEDropoutDSpin->objectName(), QString::number(convertEventRate(dropoutER)));
    }

    setHazardRatio();
}

void gsDesign::on_ssTEExpDSpin_valueChanged()
{
    experimentalER = ui->ssTEExpDSpin->value();

    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(ui->ssTEExpDSpin->objectName(), QString::number(convertEventRate(experimentalER)));
    }

    setHazardRatio();
}

void gsDesign::on_ssTECtrlDSpin_valueChanged()
{
    controlER = ui->ssTECtrlDSpin->value();

    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(ui->ssTECtrlDSpin->objectName(), QString::number(convertEventRate(controlER),'f',std::numeric_limits<double>::digits10));
    }

    setHazardRatio();
}

void gsDesign::on_ssTESwitchCombo_currentIndexChanged(int )
{
    setTimeToEventSuffixes();
    updateTimeToEventValues();
    if ( ui->ssTESwitchCombo->currentIndex() < 1 )
    {
      ui->ssTECtrlDSpin->setStep( 0.005 );
      ui->ssTEExpDSpin->setStep( 0.005 );
      ui->ssTEDropoutDSpin->setStep( 0.005 );
    }
    else
    {
      ui->ssTECtrlDSpin->setStep( 0.5 );
      ui->ssTEExpDSpin->setStep( 0.5 );
      ui->ssTEDropoutDSpin->setStep( 0.5 );
    }
    updateDesignMapQComboBox(ui->ssTESwitchCombo);
}

void gsDesign::on_ssBinFixedSpin_valueChanged(int )
{
    updateDesignMapQSpinBox(ui->ssBinFixedSpin);
}

void gsDesign::on_ssBinSupCombo_currentIndexChanged(int )
{
    QString testing = ui->ssBinSupCombo->currentText();
    bool isSuperior = (testing == "Superiority");
    ui->ssBinDeltaDSpin->setEnabled(!isSuperior);

    // set delta=0 if isSuperior
    if (isSuperior)
    {
        ui->ssBinDeltaDSpin->setValue(0.0);
    }

    updateDesignMapQComboBox(ui->ssBinSupCombo);
}

void gsDesign::on_ssBinDeltaDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssBinDeltaDSpin);
}

void gsDesign::on_ssBinExpDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssBinExpDSpin);
}

void gsDesign::on_ssBinControlDSpin_valueChanged()
{
    setDeltaRange();
    updateDesignMapQDoubleSpinBox(ui->ssBinControlDSpin);
}

void gsDesign::on_ssBinRatioDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->ssBinRatioDSpin);
}

void gsDesign::on_ssUserFixedSpin_valueChanged(int )
{
    updateDesignMapQSpinBox(ui->ssUserFixedSpin);
}

void gsDesign::updateTimeToEventValues()
{
    double LN2 = log(2.0);
//    int precision;
    QString accrual = ui->ssTEAccrualCombo->currentText();
    QString TEswitch = ui->ssTESwitchCombo->currentText();

    if (accrual == "Exponential")
    {
        ui->ssTESwitchCombo->setCurrentIndex(0);
        return;
    }

    QwtCounter *control = ui->ssTECtrlDSpin;
    QwtCounter *experimental = ui->ssTEExpDSpin;
    QwtCounter *dropout = ui->ssTEDropoutDSpin;

//    control->setDecimals(16);
//    experimental->setDecimals(16);
//    dropout->setDecimals(16);

    controlER = LN2 / controlER;
    experimentalER = LN2 / experimentalER;
    dropoutER = LN2 / dropoutER;

//printf( "controlER = %9.7f, experimentalER = %9.7f, dropoutER = %9.7f\n", controlER, experimentalER, dropoutER);

    control->setValue(controlER);
    experimental->setValue(experimentalER);
    dropout->setValue(dropoutER);

//    if (TEswitch == "Event Rate")
//    {
//        precision = 5;
//    }
//    else
//    {
//        precision = 3;
//    }
//    control->setDecimals(precision);
//    experimental->setDecimals(precision);
//    dropout->setDecimals(precision);
}

double gsDesign::convertEventRate(double val)
{
    QString TEswitch = ui->ssTESwitchCombo->currentText();
//printf( "1) val = %19.8f\n",val);

    if (TEswitch == "Median Time")
    {
        val = log(2.0) / val;
    }
//printf( "2)val = %19.8f\n",val);

    return val;
}

////
// SPENDING FUNCTION SLOTS
////

// LOWER SPENDING

void gsDesign::setSpendingPointsBounds(QwtCounter *dspin1, QwtCounter *dspin2)
{
    double val1 = dspin1->value();
    double tol = 0.001;
    double max1 = 1.0 - 2 * tol;
    double max2 = 1.0 - tol;
    double min1 = tol;
    double min2 = val1 + tol;

    if (min2 > max2)
    {
        min2 = max2;
    }

    dspin1->setMinValue(min1);
    dspin1->setMaxValue(max1);
    dspin2->setMinValue(min2);
    dspin2->setMaxValue(max2);
}

void gsDesign::on_sflPieceUseInterimRadio_toggled(bool )
{
    updateDesignMapQRadioButton(ui->sflPieceUseInterimRadio);
}

void gsDesign::on_sflPieceTableX_cellChanged(int, int )
{
    formatTable(ui->sflPieceTableX, 0.0001, 0.9999);
    updateDesignMapQTableWidget(ui->sflPieceTableX);
}

void gsDesign::on_sflPieceTableY_cellChanged(int, int )
{
    formatTable(ui->sflPieceTableY, 0.0001, 0.9999);
    updateDesignMapQTableWidget(ui->sflPieceTableY);
}

void gsDesign::on_sflPiecePtsSpin_valueChanged(int )
{
    spendingFunctionPiecewiseTableNROWUpdate(ui->sflPieceUseInterimRadio, ui->sflPiecePtsSpin, ui->sflPieceTableX, ui->sflPieceTableY);
    updateDesignMapQSpinBox(ui->sflPiecePtsSpin);
}

void gsDesign::on_sfl3PLMDfDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl3PLMDfDSpin);
}

void gsDesign::on_sfl3PLMIntDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl3PLMIntDSpin);
}

void gsDesign::on_sfl3PLMSlpDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl3PLMSlpDSpin);
}

void gsDesign::on_sfl3PPtsDfDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl3PPtsDfDSpin);
}

void gsDesign::on_sfl3PPt2YDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl3PPt2YDSpin);
}

void gsDesign::on_sfl3PPt2XDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl3PPt2XDSpin);
}

void gsDesign::on_sfl3PPt1XDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfl3PPt1XDSpin, ui->sfl3PPt2XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl3PPt1XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl3PPt2XDSpin);
}

void gsDesign::on_sfl3PPt1YDSpin_valueChanged( )
{
    setSpendingPointsBounds(ui->sfl3PPt1YDSpin, ui->sfl3PPt2YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl3PPt1YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl3PPt2YDSpin);
}

void gsDesign::on_sfl2PLMIntDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl2PLMIntDSpin);
}

void gsDesign::on_sfl2PLMSlpDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl2PLMSlpDSpin);
}

void gsDesign::on_sfl2PPt2YDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl2PPt2YDSpin);
}

void gsDesign::on_sfl2PPt2XDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl2PPt2XDSpin);
}

void gsDesign::on_sfl2PPt1YDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfl2PPt1YDSpin, ui->sfl2PPt2YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl2PPt1YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl2PPt2YDSpin);
}

void gsDesign::on_sfl2PPt1XDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfl2PPt1XDSpin, ui->sfl2PPt2XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl2PPt1XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfl2PPt2XDSpin);
}

void gsDesign::on_sfl2PFunCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->sfl2PFunCombo);
}

void gsDesign::on_sfl1PDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfl1PDSpin);
}

void gsDesign::on_sfl0PCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->sfl0PCombo);
}

void gsDesign::on_sflLBTCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->sflLBTCombo);
}

void gsDesign::on_sflLBSCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->sflLBSCombo);
}

void gsDesign::on_sflPieceUseInterimRadio_clicked(bool )
{
    spendingFunctionPiecewiseTableNROWUpdate(ui->sflPieceUseInterimRadio, ui->sflPiecePtsSpin, ui->sflPieceTableX, ui->sflPieceTableY);
}

void gsDesign::on_sfl1PCombo_currentIndexChanged(int )
{
    initialize1ParamSpending(ui->sfl1PCombo, ui->sfl1PDSpin, gsDesign::LowerSpending);
    updateDesignMapQComboBox(ui->sfl1PCombo);
}

// UPPER SPENDING

void gsDesign::on_sfuPieceUseInterimRadio_toggled(bool )
{
    updateDesignMapQRadioButton(ui->sfuPieceUseInterimRadio);
}

void gsDesign::on_sfuPieceTableX_cellChanged(int, int )
{
    formatTable(ui->sfuPieceTableX, 0.0001, 0.9999);
    updateDesignMapQTableWidget(ui->sfuPieceTableX);
}

void gsDesign::on_sfuPieceTableY_cellChanged(int, int )
{
    formatTable(ui->sfuPieceTableY, 0.0001, 0.9999);
    updateDesignMapQTableWidget(ui->sfuPieceTableY);
}

void gsDesign::on_sfu3PLMDfDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu3PLMDfDSpin);
}

void gsDesign::on_sfu3PLMIntDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu3PLMIntDSpin);
}

void gsDesign::on_sfu3PLMSlpDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu3PLMSlpDSpin);
}

void gsDesign::on_sfu3PPtsDfDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu3PPtsDfDSpin);
}

void gsDesign::on_sfu3PPt2YDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu3PPt2YDSpin);
}

void gsDesign::on_sfu3PPt2XDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu3PPt2XDSpin);
}

void gsDesign::on_sfu3PPt1YDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfu3PPt1YDSpin, ui->sfu3PPt2YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu3PPt1YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu3PPt2YDSpin);
}

void gsDesign::on_sfu3PPt1XDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfu3PPt1XDSpin, ui->sfu3PPt2XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu3PPt1XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu3PPt2XDSpin);
}

void gsDesign::on_sfu2PLMIntDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu2PLMIntDSpin);
}

void gsDesign::on_sfu2PLMSlpDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu2PLMSlpDSpin);
}

void gsDesign::on_sfu2PPt2XDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu2PPt2XDSpin);
}

void gsDesign::on_sfu2PPt2YDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu2PPt2YDSpin);
}

void gsDesign::on_sfu2PPt1YDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfu2PPt1YDSpin, ui->sfu2PPt2YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu2PPt1YDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu2PPt2YDSpin);
}

void gsDesign::on_sfu2PPt1XDSpin_valueChanged()
{
    setSpendingPointsBounds(ui->sfu2PPt1XDSpin, ui->sfu2PPt2XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu2PPt1XDSpin);
    updateDesignMapQDoubleSpinBox(ui->sfu2PPt2XDSpin);
}

void gsDesign::on_sfu2PFunCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->sfu2PFunCombo);
}

void gsDesign::on_sfu1PDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->sfu1PDSpin);
}

void gsDesign::on_sfu0PCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->sfu0PCombo);
}

void gsDesign::on_sfuPiecePtsSpin_valueChanged(int )
{
    spendingFunctionPiecewiseTableNROWUpdate(ui->sfuPieceUseInterimRadio, ui->sfuPiecePtsSpin, ui->sfuPieceTableX, ui->sfuPieceTableY);
    updateDesignMapQSpinBox(ui->sfuPiecePtsSpin);
}

void gsDesign::on_sfuPieceUseInterimRadio_clicked(bool )
{
    spendingFunctionPiecewiseTableNROWUpdate(ui->sfuPieceUseInterimRadio, ui->sfuPiecePtsSpin, ui->sfuPieceTableX, ui->sfuPieceTableY);
}

void gsDesign::on_sfu1PCombo_currentIndexChanged(int )
{
    initialize1ParamSpending(ui->sfu1PCombo, ui->sfu1PDSpin, gsDesign::UpperSpending);
    updateDesignMapQComboBox(ui->sfu1PCombo);
}


////
// ANLAYSIS
////

void gsDesign::on_anlSampleSizeTable_cellChanged(int, int)
{
    formatTable(ui->anlSampleSizeTable, -1.0, (double) 1e6);
    updateDesignMapQTableWidget(ui->anlSampleSizeTable);
}

void gsDesign::on_anlPowerDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->anlPowerDSpin);
}

void gsDesign::on_anlErrorDSpin_valueChanged()
{
    updateDesignMapQDoubleSpinBox(ui->anlErrorDSpin);
}

void gsDesign::on_anlMaxSampleSizeSpin_valueChanged(int nrowNew)
{
    int nrowOld = ui->anlSampleSizeTable->rowCount();
    ui->anlSampleSizeTable->setRowCount(nrowNew);
    double val;


    if (nrowNew > nrowOld)
    {
        for (int i = nrowOld; i < nrowNew; i++)
        {
            val = ui->anlSampleSizeTable->item(i-1,0)->text().toDouble() + 0.1;
            QTableWidgetItem *item = new QTableWidgetItem(QString::number(val));
            item->setTextAlignment(Qt::AlignRight);
            ui->anlSampleSizeTable->setItem(i,0,item);
        }
    }
    updateDesignMapQSpinBox(ui->anlMaxSampleSizeSpin);
}

////
// OUTPUT
////

void gsDesign::on_menuActionExportAllDesigns_triggered()
{
    exportAllDesigns();
}

void gsDesign::on_toolbarActionExportPlot_triggered()
{
    exportPlot();
}

void gsDesign::on_menuActionExportPlot_triggered()
{
    exportPlot();
}

void gsDesign::on_toolbarActionEditPlot_triggered()
{
    if (!plotSwitch)
    {
        lastModeStack = ui->modeStack->currentIndex();
        ui->modeStack->setCurrentIndex(3);
        ui->toolbarActionEditPlot->setText("Edit Design");
        ui->dnGroup->setEnabled(false);
        ui->outputTab->setCurrentIndex(1); // select plot tab
    }
    else
    {
        ui->modeStack->setCurrentIndex(lastModeStack);
        ui->toolbarActionEditPlot->setText("Edit Plot");
        ui->dnGroup->setEnabled(true);
    }

    plotSwitch = !plotSwitch;
}

void gsDesign::on_opTypeCombo_currentIndexChanged()
{
    blockPlotSignals(true);
    updateOutputPlotMap(getMap);
    updateDesignMapQComboBox(ui->opTypeCombo);
    updateDesignMapQLineEdit(ui->opTitleLine);
    updateDesignMapQLineEdit(ui->opXLabelLine);
    updateDesignMapQLineEdit(ui->opYLabelLeftLine);
    updateDesignMapQSpinBox(ui->opLine1WidthSpin);
    updateDesignMapQComboBox(ui->opLine1ColorCombo);
    updateDesignMapQComboBox(ui->opLine1TypeCombo);
    updateDesignMapQSpinBox(ui->opLine1SymDigitsSpin);
    updateDesignMapQSpinBox(ui->opLine2WidthSpin);
    updateDesignMapQComboBox(ui->opLine2ColorCombo);
    updateDesignMapQComboBox(ui->opLine2TypeCombo);
    updateDesignMapQSpinBox(ui->opLine2SymDigitsSpin);
    blockPlotSignals(false);

    setPlotWidgetsEnable();
    runDesign();
}

void gsDesign::on_opTitleLine_textChanged(QString text)
{
    update_opWidgetMapEntry("main", text);
    updateDesignMapQLineEdit(ui->opTitleLine);
}

void gsDesign::on_opXLabelLine_textChanged(QString text)
{
    update_opWidgetMapEntry("xlab", text);
    updateDesignMapQLineEdit(ui->opXLabelLine);
}

void gsDesign::on_opYLabelLeftLine_textChanged(QString text)
{
    update_opWidgetMapEntry("ylabLeft", text);
    updateDesignMapQLineEdit(ui->opYLabelLeftLine);
}

void gsDesign::on_opLine1WidthSpin_valueChanged(QString text)
{
    update_opWidgetMapEntry("lwd1", text);
    updateDesignMapQSpinBox(ui->opLine1WidthSpin);
    runDesign();
}

void gsDesign::on_opLine2WidthSpin_valueChanged(QString text)
{
    update_opWidgetMapEntry("lwd2", text);
    updateDesignMapQSpinBox(ui->opLine2WidthSpin);
    runDesign();
}

void gsDesign::on_opLine1ColorCombo_currentIndexChanged(int index)
{
    update_opWidgetMapEntry("col1", QString::number(index));
    updateDesignMapQComboBox(ui->opLine1ColorCombo);
    runDesign();
}

void gsDesign::on_opLine2ColorCombo_currentIndexChanged(int index)
{
    update_opWidgetMapEntry("col2", QString::number(index));
    updateDesignMapQComboBox(ui->opLine2ColorCombo);
    runDesign();
}

void gsDesign::on_opLine1TypeCombo_currentIndexChanged(int index)
{
    update_opWidgetMapEntry("lty1", QString::number(index));
    updateDesignMapQComboBox(ui->opLine1TypeCombo);
    runDesign();
}

void gsDesign::on_opLine2TypeCombo_currentIndexChanged(int index)
{
    update_opWidgetMapEntry("lty2", QString::number(index));
    updateDesignMapQComboBox(ui->opLine2TypeCombo);
    runDesign();
}

void gsDesign::on_dnModeCombo_currentIndexChanged(QString mode)
{
    bool isDesign = (mode == "Design");
    bool isAnalysis = (mode == "Analysis");
    ui->toolbarActionNewDesign->setEnabled(isDesign);
    ui->toolbarActionDeleteDesign->setEnabled(isDesign);
    ui->dnNameCombo->setEnabled(isDesign);
    ui->dnDescCombo->setEnabled(isDesign);

    if (isAnalysis && !designRunOnce)
    {
        runDesign();
    }

    updateDesignMapQComboBox(ui->dnModeCombo);
}

void gsDesign::on_dnModeCombo_currentIndexChanged(int index)
{
  ui->modeStack->setCurrentIndex( index );
}

////
// DESIGN LIST
////

QString gsDesign::QComboBoxIndexToQString(QComboBox *combo)
{
    return QString::number(combo->currentIndex());
}

QString gsDesign::QDoubleSpinBoxValueToQString(QwtCounter *dspin)
{
    return QString::number(dspin->value());
}

QString gsDesign::QSpinBoxValueToQString(QSpinBox *spin)
{
    return QString::number(spin->value());
}

QString gsDesign::QTableWidgetToQString(QTableWidget *table)
{
    int i, j;
    QTableWidgetItem *item;
    QString str ="";
    int nrow = table->rowCount();
    int ncol = table->columnCount();

    for (j = 0; j < ncol; j++)
    {
        for (i = 0; i < nrow; i++)
        {
            item = table->item(i, j);

            // ensure item is not NULL, otherwise the application will crash!
            if (!item)
            {
                continue;
            }

            if (j == ncol - 1 && i == nrow - 1)
            {
                str += item->text();
            }
            else
            {
                str += item->text() + ",";
            }
        }
    }

    return str;
}

void gsDesign::updateDesignMapQComboBox(QComboBox *combo)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(combo->objectName() + ".index", QString::number(combo->currentIndex()));
        design->insert(combo->objectName() + ".string", combo->currentText());
    }
}

void gsDesign::updateDesignMapQDoubleSpinBox(QwtCounter *dspin)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(dspin->objectName(), QString::number(dspin->value()));
    }
}

void gsDesign::updateDesignMapQSpinBox(QSpinBox *spin)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(spin->objectName(), QString::number(spin->value()));
    }
}

void gsDesign::updateDesignMapQTabWidget(QTabWidget *tab)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(tab->objectName() + ".index", QString::number(tab->currentIndex()));
        design->insert(tab->objectName() + ".string", tab->tabText(tab->currentIndex()));
    }
}

void gsDesign::updateDesignMapQToolBox(QToolBox *page)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(page->objectName() + ".index", QString::number(page->currentIndex()));
        design->insert(page->objectName() + ".string", page->currentWidget()->objectName());
    }
}

void gsDesign::updateDesignMapQTableWidget(QTableWidget *table)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(table->objectName() + ".nrow", QString::number(table->rowCount()));
        design->insert(table->objectName() + ".ncol", QString::number(table->columnCount()));
        design->insert(table->objectName() + ".data", QTableWidgetToQString(table));
    }
}

void gsDesign::updateDesignMapQRadioButton(QRadioButton *button)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(button->objectName(), QString::number(button->isChecked()));
    }
}

void gsDesign::updateDesignMapQLineEdit(QLineEdit *line)
{
    if (!designList.isEmpty())
    {
        int index = ui->dnNameCombo->currentIndex();
        QMap<QString, QString> *design = &designList[index];
        design->insert(line->objectName(), line->displayText());
    }
}

QMap<QString, QString> gsDesign::updateDesignMap()
{
    QMap<QString, QString> design;

    // QComboBox
    foreach (QComboBox *combo, ui->gsDesignMainWidget->findChildren<QComboBox*>()) {
        design.insert(combo->objectName() + ".index", QString::number(combo->currentIndex()));
        design.insert(combo->objectName() + ".string", combo->currentText());
    }

    // QDoubleSpinBox
    foreach (QwtCounter *dspin, ui->gsDesignMainWidget->findChildren<QwtCounter*>()) {
        design.insert(dspin->objectName(), QString::number(dspin->value()));
    }

    // QSpinBox
    foreach (QSpinBox *spin, ui->gsDesignMainWidget->findChildren<QSpinBox*>()) {
        design.insert(spin->objectName(), QString::number(spin->value()));
    }

    // QTabWidget
    foreach (QTabWidget *tab, ui->gsDesignMainWidget->findChildren<QTabWidget*>()) {
        design.insert(tab->objectName() + ".index", QString::number(tab->currentIndex()));
        design.insert(tab->objectName() + ".string", tab->tabText(tab->currentIndex()));
    }

    // QToolBox
    foreach (QToolBox *page, ui->gsDesignMainWidget->findChildren<QToolBox*>()) {
        design.insert(page->objectName() + ".index", QString::number(page->currentIndex()));
        design.insert(page->objectName() + ".string", page->currentWidget()->objectName());
    }

    // QTableWidget
    foreach (QTableWidget *table, ui->gsDesignMainWidget->findChildren<QTableWidget*>()) {
        design.insert(table->objectName() + ".nrow", QString::number(table->rowCount()));
        design.insert(table->objectName() + ".ncol", QString::number(table->columnCount()));
        design.insert(table->objectName() + ".data", QTableWidgetToQString(table));
    }

    // QRadioButton
    foreach (QRadioButton *radio, ui->gsDesignMainWidget->findChildren<QRadioButton*>()) {
        design.insert(radio->objectName(), QString::number(radio->isChecked()));
    }

    // QLineEdit
    foreach (QLineEdit *line, ui->gsDesignMainWidget->findChildren<QLineEdit*>()) {
        if (!line->objectName().isEmpty() && line->objectName() != "qt_spinbox_lineedit")
        {
            design.insert(line->objectName(), line->displayText());
        }
    }

    // explicitly update the survival event rates
    design.insert(ui->ssTECtrlDSpin->objectName(), QString::number(convertEventRate(controlER)));
    design.insert(ui->ssTEExpDSpin->objectName(), QString::number(convertEventRate(experimentalER)));
    design.insert(ui->ssTEDropoutDSpin->objectName(), QString::number(convertEventRate(dropoutER)));

    return design;
}

void gsDesign::designMapToQRadioButton(QRadioButton *radio)
{
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    radio->setChecked(design.value(radio->objectName()).toInt() == 1);
}

void gsDesign::designMapToQDoubleSpinBox(QwtCounter *dspin)
{
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    dspin->blockSignals(true);
    dspin->setValue(design.value(dspin->objectName()).toDouble());
    dspin->blockSignals(false);
}

void gsDesign::designMapToQSpinBox(QSpinBox *spin)
{
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    spin->blockSignals(true);
    spin->setValue(design.value(spin->objectName()).toInt());
    spin->blockSignals(false);
}

void gsDesign::designMapToQComboBox(QComboBox *combo)
{
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    combo->blockSignals(true);
    combo->setCurrentIndex(design.value(combo->objectName() + ".index").toInt());
    combo->blockSignals(false);
}

void gsDesign::designMapToQTabWidget(QTabWidget *tab)
{
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    tab->blockSignals(true);
    tab->setCurrentIndex(design.value(tab->objectName() + ".index").toInt());
    tab->blockSignals(false);
}

void gsDesign::designMapToQToolBox(QToolBox *page)
{
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    page->blockSignals(true);
    page->setCurrentIndex(design.value(page->objectName() + ".index").toInt());
    page->blockSignals(false);
}

void gsDesign::designMapToQTableWidget(QTableWidget *table)
{
    table->blockSignals(true);

    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];
    int nrow = design.value(table->objectName() + ".nrow").toInt();
    int ncol = design.value(table->objectName() + ".ncol").toInt();
    int i,j, k = 0;
    QTableWidgetItem *item;
    QString dataStr = design.value(table->objectName() + ".data");
    QStringList dataList = dataStr.split(QRegExp(","), QString::SkipEmptyParts);

    table->setRowCount(nrow);
    table->setColumnCount(ncol);

    for (j = 0; j < ncol; j++)
    {
        for (i = 0; i < nrow; i++)
        {
            if (k > nrow * ncol)
            {
                table->blockSignals(false);
                return;
            }

            item = table->item(i, j);

            if (!item)
            {
                QTableWidgetItem *newItem = new QTableWidgetItem(dataList.at(k));
                table->setItem(i, j, newItem);
                newItem->setTextAlignment(Qt::AlignRight);
            }
            else
            {
                item->setText(dataList.at(k));
                item->setTextAlignment(Qt::AlignRight);
            }

            k++;
        }
    }

    table->blockSignals(false);
}

void gsDesign::loadDesign()
{
    // QComboBox
    foreach (QComboBox *combo, ui->gsDesignMainWidget->findChildren<QComboBox*>())
    {
        if (!combo->objectName().contains(QRegExp("^dn.*Combo$")))
        {
            designMapToQComboBox(combo);
        }
    }

    // QDoubleSpinBox
    foreach (QwtCounter *dspin, ui->gsDesignMainWidget->findChildren<QwtCounter*>()) {
        designMapToQDoubleSpinBox(dspin);
    }

    // QSpinBox
    foreach (QSpinBox *spin, ui->gsDesignMainWidget->findChildren<QSpinBox*>()) {
        designMapToQSpinBox(spin);
    }

    // QTabWidget
    foreach (QTabWidget *tab, ui->gsDesignMainWidget->findChildren<QTabWidget*>()) {
        designMapToQTabWidget(tab);
    }

    // QToolBox
    foreach (QToolBox *page, ui->gsDesignMainWidget->findChildren<QToolBox*>()) {
        designMapToQToolBox(page);
    }

    // QRadioButton
    foreach (QRadioButton *radio, ui->gsDesignMainWidget->findChildren<QRadioButton*>()) {
        radio->blockSignals(true);
        designMapToQRadioButton(radio);
        radio->blockSignals(false);
    }

    // QTableWidget
    foreach (QTableWidget *table, ui->gsDesignMainWidget->findChildren<QTableWidget*>()) {
        designMapToQTableWidget(table);
    }

    // the survival values stored in hash table related to control, experimental, and dropout
    // are always stored as event rates (and not time to event values) and thus we need to explicitly
    // populate the associated widgets accordingly.

    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];

    controlER = design.value(ui->ssTECtrlDSpin->objectName()).toDouble();
    experimentalER = design.value(ui->ssTEExpDSpin->objectName()).toDouble();
    dropoutER = design.value(ui->ssTEDropoutDSpin->objectName()).toDouble();

    ui->ssTECtrlDSpin->setValue(convertEventRate(controlER));
    ui->ssTEExpDSpin->setValue(convertEventRate(experimentalER));
    ui->ssTEDropoutDSpin->setValue(convertEventRate(dropoutER));
    \
            updateOutputPlotMap(getMap);

    // execute the first design
    runDesign();


    // set delete design toolbar and menu item visibility
    setDeleteDesignVisibility();
}

void gsDesign::on_dnNameCombo_currentIndexChanged(int index )
{
    loadDesign();
    populatePlotFromDesignQMap();
    runDesign();
	ui->dnDescCombo->setCurrentIndex( index );
}

void gsDesign::populatePlotFromDesignQMap()
{
    // update plot widgets with current design hash
    int index = ui->dnNameCombo->currentIndex();
    QMap<QString, QString> design = designList[index];

    ui->opTitleLine->setText(design.value("opTitleLine"));
    ui->opXLabelLine->setText(design.value("opXLabelLine"));
    ui->opYLabelLeftLine->setText(design.value("opYLabelLeftLine"));
    ui->opLine1WidthSpin->setValue(design.value("opLine1WidthSpin").toInt());
    ui->opLine1ColorCombo->setCurrentIndex(design.value("opLine1ColorCombo").toInt());
    ui->opLine1TypeCombo->setCurrentIndex(design.value("opLine1TypeCombo").toInt());
    ui->opLine2WidthSpin->setValue(design.value("opLine2WidthSpin").toInt());
    ui->opLine2ColorCombo->setCurrentIndex(design.value("opLine2ColorCombo").toInt());
    ui->opLine2TypeCombo->setCurrentIndex(design.value("opLine2TypeCombo").toInt());
    ui->opLine1SymDigitsSpin->setValue(design.value("opLine1SymDigitsSpin").toInt());
    ui->opLine2SymDigitsSpin->setValue(design.value("opLine2SymDigitsSpin").toInt());

    // refresh the plot hash with the values just entered into the plot widgets
    updateOutputPlotMap(setMap);
}


void gsDesign::on_toolbarActionDeleteDesign_hovered()
{
    ui->dnNameCombo->setFocus();
}

void gsDesign::on_toolbarActionNewDesign_hovered()
{
    ui->dnNameCombo->setFocus();
}

void gsDesign::on_toolbarActionRunDesign_triggered()
{
    runDesign();
}

////
// PLOT
////

void gsDesign::displayImage()
{
    if (plotFilePath.isEmpty())
    {
        return;
    }

    QFile file(plotFilePath);

    if (!file.exists())
    {
        ui->outPlot->setText("Plot " + plotFilePath + " does not exist");
        return;
    }

    QPixmap pixmap;

    pixmap.load(plotFilePath);
    ui->outPlot->setPixmap(pixmap);
    ui->outPlot->setVisible(true);
}

void gsDesign::setDefaultDesign()
{
    QString currentDesignName = ui->dnNameCombo->currentText();
    QString currentDesignDescription = ui->dnDescCombo->currentText();
    int index = ui->dnNameCombo->currentIndex();
    designList[index] = defaultDesign;
    loadDesign();

    setPlotDefaults();
    updateOutputPlotMap(setMap);

    // update design name and description in current design hash table
    ui->dnNameCombo->setItemText(index, currentDesignName);
    ui->dnDescCombo->setItemText(index, currentDesignDescription);
    updateDesignMapQComboBox(ui->dnNameCombo);
    updateDesignMapQComboBox(ui->dnDescCombo);
}

void gsDesign::on_toolbarActionDefaultDesign_triggered()
{
    setDefaultDesign();
}

void gsDesign::on_toolbarActionSaveDesign_triggered()
{
    save();
}

void gsDesign::on_menuActionSaveDesign_triggered()
{
    save();
}

void gsDesign::on_menuActionSaveAsDesign_triggered()
{
    saveAs();
}

void gsDesign::on_menuActionLoadDesign_triggered()
{
    QString fileName="";
    loadFile(fileName);
}

void gsDesign::featureNotComplete()
{
    QMessageBox::information(this, tr("Feature Status"), tr("To be completed. Please stand by ..."));
}

void gsDesign::on_menuActionExportDesign_triggered()
{
    exportDesign();
}

void gsDesign::on_toolbarActionExportDesign_triggered()
{
    exportDesign();
}

void gsDesign::on_menuActionDefaultDesign_triggered()
{
    setDefaultDesign();
}

void gsDesign::contextHelp()
{
    bool checked = ui->toolbarActionContextHelp->isChecked();

    if (checked)
    {
        QWhatsThis::enterWhatsThisMode();
    }
    else
    {
        QWhatsThis::leaveWhatsThisMode();
    }

    ui->toolbarActionContextHelp->setChecked(!checked);
}

void gsDesign::on_toolbarActionContextHelp_triggered()
{
    contextHelp();
}

void gsDesign::on_menuActionContextHelp_triggered()
{
    contextHelp();
}

void gsDesign::on_menuActionAbout_triggered()
{
    about();
}

void gsDesign::on_menuActionNewDesign_triggered()
{
    addNewDesign();
}

void gsDesign::on_menuActionDeleteDesign_triggered()
{
    deleteDesign();
}

void gsDesign::on_menuActionRunDesign_triggered()
{
    runDesign();
}

void gsDesign::setDeleteDesignVisibility()
{
    bool isSingleDesign = designList.length() == 1;
    ui->menuActionDeleteDesign->setEnabled(!isSingleDesign);
    ui->toolbarActionDeleteDesign->setEnabled(!isSingleDesign);
}

void gsDesign::setStatusTips()
{
    // QComboBox
    foreach (QComboBox *combo, ui->gsDesignMainWidget->findChildren<QComboBox*>()) {
        combo->setStatusTip(combo->objectName());
    }

    // QDoubleSpinBox
    foreach (QwtCounter *dspin, ui->gsDesignMainWidget->findChildren<QwtCounter*>()) {
        dspin->setStatusTip(dspin->objectName());
    }

    // QSpinBox
    foreach (QSpinBox *spin, ui->gsDesignMainWidget->findChildren<QSpinBox*>()) {
        spin->setStatusTip(spin->objectName());
    }

    // QTabWidget
    foreach (QTabWidget *tab, ui->gsDesignMainWidget->findChildren<QTabWidget*>()) {
        tab->setStatusTip(tab->objectName());
    }

    // QToolBox
    foreach (QToolBox *page, ui->gsDesignMainWidget->findChildren<QToolBox*>()) {
        page->setStatusTip(page->objectName());
    }

    // QTableWidget
    foreach (QTableWidget *table, ui->gsDesignMainWidget->findChildren<QTableWidget*>()) {
        table->setStatusTip(table->objectName());
    }

    // QRadioButton
    foreach (QRadioButton *radio, ui->gsDesignMainWidget->findChildren<QRadioButton*>()) {
        radio->setStatusTip(radio->objectName());
    }
}

void gsDesign::on_opLine1SymDigitsSpin_valueChanged(QString text)
{
    updateDesignMapQSpinBox(ui->opLine1SymDigitsSpin);
    update_opWidgetMapEntry("symDigits1", text);
    runDesign();
}

void gsDesign::on_opLine2SymDigitsSpin_valueChanged(QString text)
{
    updateDesignMapQSpinBox(ui->opLine2SymDigitsSpin);
    update_opWidgetMapEntry("symDigits2", text);
    runDesign();
}

////
// WORKING DIRECTORY
////

bool gsDesign::setWorkingDirectory()
{
    QString workingDirectory = QFileDialog::getExistingDirectory(this,
                                                                 tr("Select working directory"),
                                                                 currentWorkingDirectory.absolutePath(),
                                                                 QFileDialog::ShowDirsOnly
#ifdef Q_WS_WIN
                                                                 // This fixes an apparent bug in Qt on Windows
                                                                 | QFileDialog::DontUseNativeDialog
#endif
                                                                 );

    if (workingDirectory.isEmpty())
    {
        return(false);
    }

    currentWorkingDirectory.setPath(QDir::toNativeSeparators(workingDirectory));

    return(true);
}

void gsDesign::on_menuActionChangeWorkingDirectory_triggered()
{
    if (setWorkingDirectory())
    {
        statusBar()->showMessage("Working directory set to " + currentWorkingDirectory.absolutePath(), 2000);
    }
}

void gsDesign::on_toolbarActionSetWorkingDirectory_triggered()
{
    if (setWorkingDirectory())
    {
        statusBar()->showMessage("Working directory set to " + currentWorkingDirectory.absolutePath(), 2000);
    }
}

void gsDesign::enableAllWidgets(bool enable)
{
    ui->toolbarActionRunDesign->setEnabled(enable);
    ui->modeStack->setEnabled(enable);
    ui->dnGroup->setEnabled(enable);
    ui->opEdit->setEnabled(enable);

}

static bool IsErrorOrWarning(const std::string &str)
{
    if ( (str.find("Error") == 0) || (str.find("Warning") == 0) )
    {
        return true;
    }
    return false;
}


static std::string QStringToStdString(const QString &rqString)
{
    QByteArray qbaString = rqString.toLatin1();
    return (const char *)qbaString;
}

static bool CreateGsRListFromHash(GsRList &gsRList, QMap<QString, QString> &hash)
{
    int iHashSize = hash.size();

    gsRList.Init(iHashSize);

    QMap<QString, QString>::const_iterator designElement = hash.constBegin();
    while (designElement != hash.constEnd())
    {
        QByteArray qbaKey = designElement.key().toLatin1();
        QByteArray qbaValue = designElement.value().toLatin1();
        gsRList.AddElement(qbaKey, qbaValue);
        ++designElement;
    }
    return true;

}

////
// Qt-R FUNCTIONS
////

void gsDesign::blockPlotSignals(bool block)
{
    ui->opXLabelLine->blockSignals(block);
    ui->opYLabelLeftLine->blockSignals(block);
    ui->opTitleLine->blockSignals(block);
    ui->opLine1ColorCombo->blockSignals(block);
    ui->opLine1SymDigitsSpin->blockSignals(block);
    ui->opLine1TypeCombo->blockSignals(block);
    ui->opLine1WidthSpin->blockSignals(block);
    ui->opLine2ColorCombo->blockSignals(block);
    ui->opLine2SymDigitsSpin->blockSignals(block);
    ui->opLine2TypeCombo->blockSignals(block);
    ui->opLine2WidthSpin->blockSignals(block);
}

void gsDesign::runDesign()
{
    if (!GsRList::m_bAllowRunDesign || !validatePiecewiseTables() )
        return;

    // turn off plot signals
    blockPlotSignals(true);

    // disbable widget groups
    enableAllWidgets(false);

    QMap<QString, QString> hash = designList.value(ui->dnNameCombo->currentIndex());

    ////
    // R Call:
    //
    //   runDesign(designListRaw, plotPath=plotFilePath, plotBackground="transparent")
    ////

    GsRList gsRList;
    CreateGsRListFromHash(gsRList, hash);

    GsDesignResults gsdResults;
    // If there is an error message from R, the return value will be false
    // and the error message will be in sTextOutput
    bool bSuccess = gsRList.RunDesign(gsdResults);

    if (!bSuccess)
    {
        warningHandler(gsdResults.m_sTextOutput.c_str());
        ui->otEdit->setText("");
        ui->outPlot->setPixmap(QPixmap());
        plotFilePath = "";
    }
    else
    {
        QString qsTextOutput = gsdResults.m_sTextOutput.c_str();

        ui->otEdit->setText(qsTextOutput);

        plotFilePath = gsdResults.m_sNameOfPlotOutput.c_str();

        // populate fixed design widgets
        QString sampleSizeTabText = ui->sampleSizeTab->tabText(ui->sampleSizeTab->currentIndex());

        if (sampleSizeTabText == "Time to Event")
        {
            ui->ssBinFixedSpin->setValue(0);
            ui->ssTEFixedSpin->setValue(gsdResults.m_fixedSampleSize);
            ui->ssTEFixedEventSpin->setValue(gsdResults.m_fixedEvents);
        }
        else if (sampleSizeTabText == "Binomial")
        {
            ui->ssTEFixedSpin->setValue(0);
            ui->ssTEFixedEventSpin->setValue(0);
            ui->ssBinFixedSpin->setValue(gsdResults.m_fixedSampleSize);
        }
        else if (sampleSizeTabText == "User Input")
        {
            ui->ssTEFixedSpin->setValue(0);
            ui->ssTEFixedEventSpin->setValue(0);
            ui->ssBinFixedSpin->setValue(0);
        }

        if (!ui->anlLockTimesRadio->isChecked())
        {
            ui->anlMaxnIPlanDSpin->setValue(gsdResults.m_analysisMaxnIPlan);
            fillAnalysisTable(gsdResults.m_piAnalysisNI, gsdResults.m_iLenAnalysisNI);
        }

        if (!designRunOnce)
        {
            designRunOnce = true;
        }

    }

    // display output image
    displayImage();

    // re-enable the widget groups
    enableAllWidgets(true);
    setPlotWidgetsEnable();
    ui->dnGroup->setEnabled(!ui->toolbarActionEditPlot->isChecked());

    // turn plot signaling back on
    blockPlotSignals(false);
}

void gsDesign::exportPlot()
{
    QString plotType = ui->opTypeCombo->currentText();
    plotType.replace(QRegExp("[ ]+"),"");

    QString defaultFileName = currentWorkingDirectory.absolutePath() + "/" + ui->dnNameCombo->currentText() + plotType + "Plot.pdf";
    QString plotPath = QFileDialog::getSaveFileName(this,
                                                    tr("Export the current plot to file"),
                                                    defaultFileName,
                                                    tr("PDF (*.pdf);;PNG (*.png);;JPEG (*.jpg);;TIFF (*.tiff);;BMP (*.bmp)"));

    if (plotPath.isEmpty())
    {
        return;
    }

    ////
    // R Call: runDesign(designListRaw, plotPath=plotPath, plotBackground="white")
    // R Call Output: None
    ////

    QMap<QString, QString> hash = designList.value(ui->dnNameCombo->currentIndex());
    GsRList gsRList;
    CreateGsRListFromHash(gsRList, hash);
    std::string sPlotPath = QStringToStdString(plotPath);

    GsDesignResults gsdResults;
    if (gsRList.RunDesign(gsdResults, sPlotPath.c_str(), "white" /*plotBackground*/ ) == true)
    {
        statusBar()->showMessage("Plot successfully exported to " + plotPath, 2000);
    }
    else
    {
		warningHandler("Plot was not successfully exported to " + plotPath + ": " + gsdResults.m_sTextOutput.c_str());
    }
}

static bool ExportDesignFromHash(GsDesignResults &gsdResults,
								 QMap<QString, QString> &hash,
                                 std::string &sFilePath,
                                 bool bAppend,
                                 bool bWriteHeader,
                                 std::string &sgsDesignExplorerVersion)
{
    
    GsRList gsRList;
	CreateGsRListFromHash(gsRList, hash);
    ////
    // R Call: exportDesign(designListRaw, file=fileName, append=FALSE, writeHeader=TRUE, gsDesignExplorerVersion=gsDesignExplorerVersion)
    ////

    return gsRList.ExportDesign(gsdResults, sFilePath.c_str(), bAppend, bWriteHeader, sgsDesignExplorerVersion.c_str() );

}

bool gsDesign::exportDesign()
{
    QString defaultFileName = currentWorkingDirectory.absolutePath() + "/" + ui->dnNameCombo->currentText() + ".R";

    QString fileName = QFileDialog::getSaveFileName(this,
                                                    tr("Save the current design(s) to file"),
                                                    defaultFileName,
                                                    tr("R Script (*.R);;LaTeX (*.tex);;Rich Text Format (*.rtf);;Sweave (*.Rnw)"));

    if (fileName.isEmpty())
    {
        return false;
    }

    std::string sFilePath = QStringToStdString(fileName);
    std::string sgsDesignExplorerVersion = QStringToStdString(gsDesignExplorerVersion);

    QMap<QString, QString> hash = designList.value(ui->dnNameCombo->currentIndex());
    bool bAppend = false;
    bool bWriteHeader = true;
	GsDesignResults gsdResults;
	bool bRet = ExportDesignFromHash(gsdResults, hash, sFilePath, bAppend, bWriteHeader, sgsDesignExplorerVersion);

    if (bRet)
    {
        statusBar()->showMessage("Design successfully exported to " + fileName, 2000);
    }
    else
    {
        warningHandler("Design was not successfully exported to " + fileName + ": " + gsdResults.m_sTextOutput.c_str());
    }

    return bRet;

}

bool gsDesign::exportAllDesigns()
{
    QString defaultFileName = currentWorkingDirectory.absolutePath() + "/" + ui->dnNameCombo->currentText() + "All.R";

    QString fileName = QFileDialog::getSaveFileName(this,
                                                    tr("Save the current design(s) to file"),
                                                    defaultFileName,
                                                    tr("R Script (*.R);;LaTeX (*.tex);;Rich Text Format (*.rtf);;Sweave (*.Rnw)"));

    if (fileName.isEmpty())
    {
        return false;
    }

    bool bRet = true;
    std::string sFilePath = QStringToStdString(fileName);
    std::string sgsDesignExplorerVersion = QStringToStdString(gsDesignExplorerVersion);

	QString qsErrorMessage;
    for (int i = 0; i < designList.length(); i++)
    {

        bool bAppend = false;
        bool bWriteHeader = true;
        if (i > 0)
        {
            bAppend = true;
            bWriteHeader = false;
        }

		GsDesignResults gsdResults;
		bRet = ExportDesignFromHash(gsdResults, designList[i], sFilePath, bAppend, bWriteHeader, sgsDesignExplorerVersion);
        if (!bRet)
		{
			qsErrorMessage = gsdResults.m_sTextOutput.c_str();
            break;
		}
    }

    if (bRet)
    {
        statusBar()->showMessage("Designs successfully exported to " + fileName, 2000);
    }
    else
    {
        warningHandler("Designs were not successfully exported to " + fileName + ": " + qsErrorMessage);
    }


    return(true);
}

void gsDesign::errorHandler(QString error)
{
    QMessageBox::critical(this, "gsDesignExplorer " + gsDesignExplorerVersion, error, QMessageBox::Ok);
}

void gsDesign::warningHandler(QString warning)
{
    QMessageBox::warning(this, "gsDesignExplorer " + gsDesignExplorerVersion, warning, QMessageBox::Ok);
}

void gsDesign::informationHandler(QString information)
{
    QMessageBox::information(this, "gsDesignExplorer " + gsDesignExplorerVersion, information, QMessageBox::Ok);
}

void gsDesign::on_menuActionPlotDefaults_triggered()
{
    setPlotDefaults();
}


void gsDesign::on_menuActionOpenManual_triggered()
{
    ////
    // R Call: openGSDesignExplorerManual()
    ////

    std::string str = EvaluateRExpression("openGSDesignGUIManual()");

    if ( IsErrorOrWarning(str) )
    {
        warningHandler(str.c_str());
    }

    ////
    // R Call Output: None. Call may throw an error if file not found, package not loaded, etc.
    ////
}

void gsDesign::on_opPlotRenderCombo_currentIndexChanged(int )
{
    updateDesignMapQComboBox(ui->opPlotRenderCombo);
    runDesign();
}

void gsDesign::on_opTitleLine_editingFinished()
{
    runDesign();
}

void gsDesign::on_opXLabelLine_editingFinished()
{
    runDesign();
}

void gsDesign::on_opYLabelLeftLine_editingFinished()
{
    runDesign();
}

void gsDesign::quit()
{
    delete ui;
    ui = 0;
    QTimer::singleShot(0, qApp, SLOT(quit()));
}

void gsDesign::on_menuActionExit_triggered()
{
    quit();
}

void gsDesign::on_menuActionAutoscalePlot_toggled(bool toggled)
{
    ui->outPlot->setScaledContents(toggled);
}

void gsDesign::fillAnalysisTable(double *array, int len)
{
    QTableWidgetItem *item;

    ui->anlSampleSizeTable->setRowCount(len);

    for (int i = 0; i < len; i++)
    {
        double val = array[i];

        // get tableWidgetItem
        item = ui->anlSampleSizeTable->item(i, 0);

        // ensure item is not NULL
        if (!item)
        {
            QTableWidgetItem *newItem = new QTableWidgetItem();
            newItem->setData(Qt::DisplayRole, val);
            ui->anlSampleSizeTable->setItem(i, 0, newItem);
            newItem->setTextAlignment(Qt::AlignRight);
        }
        else
        {
            item->setData(Qt::DisplayRole, val);
            item->setTextAlignment(Qt::AlignRight);
        }
    }

    ui->anlMaxSampleSizeSpin->setValue(len);
}

bool gsDesign::isValidPiecewiseTable(QTableWidget *table, QSpinBox *spin, int *emptyIndex)
{
    int points = spin->value();
    int nrow = table->rowCount();
    int nValid = 0;
    QTableWidgetItem *item;

    if (points != nrow)
    {
        return false;
    }

    for (int i = 0; i < nrow; i++)
    {
        item = table->item(i, 0);

        if (!item || item->text().isEmpty())
        {
            continue;
        }

        nValid++;
    }

    if (nValid != nrow)
    {
        *emptyIndex = nValid;
        return false;
    }

    return true;
}

bool gsDesign::validatePiecewiseTables()
{
    bool isSpending = ui->designTab->tabText(ui->designTab->currentIndex()) == "Spending Functions";
    int emptyIndex;

    if (isSpending)
    {
        bool isLowerSpending = ui->spendingFunctionTab->tabText(ui->spendingFunctionTab->currentIndex()) == "Lower Spending";

        if (isLowerSpending)
        {
            bool isTwoSidedFutility = ui->sflTestCombo->currentText() == "2-sided with futility";

            if (isTwoSidedFutility)
            {
                bool isPiecewise = ui->sflParamToolBox->currentWidget()->objectName().contains("PiecewiseLinear", Qt::CaseSensitive);

                if (isPiecewise)
                {
                    if (!isValidPiecewiseTable(ui->sflPieceTableX, ui->sflPiecePtsSpin, &emptyIndex))
                    {
                        ui->sflPieceTableX->selectRow(emptyIndex);
                        errorHandler("Piecewise linear lower spending function X Table is not filled.");
                        return false;
                    }

                    if (!isValidPiecewiseTable(ui->sflPieceTableY, ui->sflPiecePtsSpin, &emptyIndex))
                    {
                        ui->sflPieceTableY->selectRow(emptyIndex);
                        errorHandler("Piecewise linear lower spending function Y Table is not filled.");
                        return false;
                    }
                }
            }
        }
        else  // upper spending
        {
            bool isPiecewise = ui->sfuParamToolBox->currentWidget()->objectName().contains("PiecewiseLinear", Qt::CaseSensitive);

            if (isPiecewise)
            {
                if (!isValidPiecewiseTable(ui->sfuPieceTableX, ui->sfuPiecePtsSpin, &emptyIndex))
                {
                    ui->sfuPieceTableX->selectRow(emptyIndex);
                    errorHandler("Piecewise linear upper spending function X Table is not filled.");
                    return false;
                }

                if (!isValidPiecewiseTable(ui->sfuPieceTableY, ui->sfuPiecePtsSpin, &emptyIndex))
                {
                    ui->sfuPieceTableY->selectRow(emptyIndex);
                    errorHandler("Piecewise linear upper spending function Y Table is not filled.");
                    return false;
                }
            }
        }
    }

    return true;
}

void gsDesign::setHazardRatio()
{
    QString TEswitch = ui->ssTESwitchCombo->currentText();
    double hazard = experimentalER / controlER;

    if (TEswitch == "Median Time")
    {
        hazard = 1.0 / hazard;
    }

    ui->ssTEHazardRatioDSpin->setValue(hazard);
}
