/********************************************************************************
** Form generated from reading UI file 'gsdesign.ui'
**
** Created: Fri Aug 12 19:45:20 2011
**      by: Qt User Interface Compiler version 4.7.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GSDESIGN_H
#define UI_GSDESIGN_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QComboBox>
#include <QtGui/QFrame>
#include <QtGui/QGridLayout>
#include <QtGui/QGroupBox>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QRadioButton>
#include <QtGui/QSpacerItem>
#include <QtGui/QSpinBox>
#include <QtGui/QStackedWidget>
#include <QtGui/QStatusBar>
#include <QtGui/QTabWidget>
#include <QtGui/QTableWidget>
#include <QtGui/QTextEdit>
#include <QtGui/QToolBar>
#include <QtGui/QToolBox>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>
#include "qwt_counter.h"
#include "qwt_slider.h"

QT_BEGIN_NAMESPACE

class Ui_gsDesign
{
public:
    QAction *toolbarActionSaveDesign;
    QAction *menuActionLoadDesign;
    QAction *toolbarActionLoadDesign;
    QAction *toolbarActionNewDesign;
    QAction *toolbarActionRunDesign;
    QAction *menuActionOpenManual;
    QAction *menuActionContextHelp;
    QAction *menuActionAbout;
    QAction *toolbarActionContextHelp;
    QAction *menuActionDefaultDesign;
    QAction *toolbarActionDeleteDesign;
    QAction *menuActionSaveDesign;
    QAction *menuActionSaveAsDesign;
    QAction *menuActionExportDesign;
    QAction *toolbarActionDefaultDesign;
    QAction *menuActionNewDesign;
    QAction *menuActionDeleteDesign;
    QAction *menuActionRunDesign;
    QAction *toolbarActionExportDesign;
    QAction *menuActionEditPlot;
    QAction *menuActionExportPlot;
    QAction *toolbarActionEditPlot;
    QAction *toolbarActionExportPlot;
    QAction *menuActionChangeWorkingDirectory;
    QAction *menuActionExportAllDesigns;
    QAction *toolbarActionSetWorkingDirectory;
    QAction *menuActionPlotDefaults;
    QAction *menuActionExit;
    QAction *menuActionAutoscalePlot;
    QWidget *gsDesignMainWidget;
    QWidget *layoutWidget;
    QGridLayout *gridLayout_61;
    QGroupBox *dnGroup;
    QWidget *navLayoutWidget;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout;
    QComboBox *dnModeCombo;
    QComboBox *dnNameCombo;
    QSpacerItem *horizontalSpacer_38;
    QComboBox *dnDescCombo;
    QStackedWidget *modeStack;
    QWidget *DesignPage;
    QGridLayout *gridLayout_65;
    QTabWidget *designTab;
    QWidget *eptTab;
    QGridLayout *gridLayout_74;
    QSpacerItem *verticalSpacer_15;
    QSpacerItem *horizontalSpacer_9;
    QVBoxLayout *verticalLayout_9;
    QGroupBox *eptErrorPowerGroup;
    QGridLayout *gridLayout_66;
    QGridLayout *gridLayout_39;
    QLabel *eptErrorLabel;
    QwtCounter *eptErrorDSpin;
    QLabel *eptPowerLabel;
    QwtCounter *eptPowerDSpin;
    QwtSlider *eptPowerHSlider;
    QwtSlider *eptErrorHSlider;
    QSpacerItem *verticalSpacer_14;
    QGroupBox *tdTimingGroup;
    QGridLayout *gridLayout_41;
    QGridLayout *gridLayout_2;
    QLabel *eptIntervalsLabel;
    QSpinBox *eptIntervalsSpin;
    QLabel *eptSpacingLabel;
    QComboBox *eptSpacingCombo;
    QLabel *eptSpacingLabel_2;
    QTableWidget *eptTimingTable;
    QSpacerItem *horizontalSpacer_10;
    QSpacerItem *verticalSpacer_16;
    QWidget *ss;
    QGridLayout *gridLayout_75;
    QTabWidget *sampleSizeTab;
    QWidget *ssUserTab;
    QGridLayout *gridLayout_82;
    QSpacerItem *verticalSpacer_17;
    QSpacerItem *horizontalSpacer_11;
    QGridLayout *gridLayout_6;
    QLabel *ssUserFixedLabel;
    QSpinBox *ssUserFixedSpin;
    QSpacerItem *horizontalSpacer_13;
    QSpacerItem *verticalSpacer_19;
    QWidget *ssBinTab;
    QGridLayout *gridLayout_98;
    QGroupBox *ssBinEventGroup;
    QGridLayout *gridLayout_71;
    QGridLayout *gridLayout_70;
    QLabel *ssBinRatioLabel;
    QwtCounter *ssBinRatioDSpin;
    QLabel *ssBinControlLabel;
    QwtCounter *ssBinControlDSpin;
    QLabel *ssBinExpLabel;
    QwtCounter *ssBinExpDSpin;
    QGroupBox *ssBinTestingGroup;
    QGridLayout *gridLayout_69;
    QComboBox *ssBinSupCombo;
    QGridLayout *gridLayout_37;
    QLabel *ssBinDeltaLabel;
    QwtCounter *ssBinDeltaDSpin;
    QGroupBox *groupBox_3;
    QGridLayout *gridLayout_67;
    QGridLayout *gridLayout_32;
    QLabel *ssBinSSLabel;
    QSpinBox *ssBinFixedSpin;
    QSpacerItem *horizontalSpacer_2;
    QSpacerItem *verticalSpacer_9;
    QSpacerItem *horizontalSpacer_3;
    QSpacerItem *verticalSpacer_8;
    QWidget *ssTETab;
    QGridLayout *gridLayout_73;
    QSpacerItem *horizontalSpacer_4;
    QGroupBox *ssTEAccrualGroup;
    QGridLayout *gridLayout_72;
    QVBoxLayout *ssTEAccrualLayout;
    QComboBox *ssTEAccrualCombo;
    QGridLayout *ssTEGammaLayout;
    QLabel *ssTEGammaLabel;
    QwtCounter *ssTEGammaDSpin;
    QSpacerItem *verticalSpacer_11;
    QSpacerItem *verticalSpacer_12;
    QGroupBox *ssTEOtherGroup;
    QGridLayout *gridLayout_54;
    QGridLayout *gridLayout_46;
    QLabel *ssTEAccrualLabel;
    QwtCounter *ssTEAccrualDSpin;
    QLabel *ssTEFollowLabel;
    QwtCounter *ssTEFollowDSpin;
    QLabel *ssTERatioLabel;
    QwtCounter *ssTERatioDSpin;
    QLabel *ssTEHypLabel;
    QComboBox *ssTEHypCombo;
    QSpacerItem *horizontalSpacer_5;
    QGroupBox *groupBox;
    QGridLayout *gridLayout_57;
    QGridLayout *gridLayout_56;
    QLabel *ssTEFixedLabel;
    QSpinBox *ssTEFixedSpin;
    QLabel *ssTEFixedEventLabel;
    QSpinBox *ssTEFixedEventSpin;
    QGroupBox *ssTEGroup;
    QGridLayout *gridLayout_55;
    QGridLayout *gridLayout_47;
    QComboBox *ssTESwitchCombo;
    QLabel *ssTECtrlLabel;
    QwtCounter *ssTECtrlDSpin;
    QLabel *ssTEExpLabel;
    QwtCounter *ssTEExpDSpin;
    QLabel *label;
    QLabel *ssTEDropoutLabel;
    QwtCounter *ssTEDropoutDSpin;
    QwtCounter *ssTEHazardRatioDSpin;
    QLabel *ssTEHazardRatioLabel;
    QFrame *line;
    QFrame *line_2;
    QWidget *sf;
    QGridLayout *gridLayout_68;
    QTabWidget *spendingFunctionTab;
    QWidget *sflTab;
    QGridLayout *gridLayout_64;
    QToolBox *sflParamToolBox;
    QWidget *LParameterFree;
    QGridLayout *gridLayout_90;
    QSpacerItem *verticalSpacer_35;
    QSpacerItem *horizontalSpacer_26;
    QGridLayout *sfl0PLLayout;
    QComboBox *sfl0PCombo;
    QLabel *sfl0PLabel;
    QSpacerItem *horizontalSpacer_27;
    QSpacerItem *verticalSpacer_34;
    QWidget *LOneParameter;
    QGridLayout *gridLayout_89;
    QSpacerItem *verticalSpacer_32;
    QSpacerItem *horizontalSpacer_24;
    QGridLayout *gridLayout_88;
    QComboBox *sfl1PCombo;
    QwtCounter *sfl1PDSpin;
    QSpacerItem *horizontalSpacer_25;
    QSpacerItem *verticalSpacer_33;
    QWidget *LTwoParameter;
    QGridLayout *gridLayout_87;
    QSpacerItem *verticalSpacer_31;
    QTabWidget *sfl2PTab;
    QWidget *sfl2PFunTab;
    QGridLayout *gridLayout_60;
    QVBoxLayout *verticalLayout_7;
    QGridLayout *sfl2PFunLayout;
    QLabel *sfl2PFunLabel;
    QComboBox *sfl2PFunCombo;
    QGridLayout *gridLayout_11;
    QGroupBox *sfl2PPt1Group;
    QGridLayout *gridLayout_12;
    QGridLayout *gridLayout_10;
    QLabel *sfl2PPt1XLabel;
    QwtCounter *sfl2PPt1XDSpin;
    QLabel *sfl2PPt1YLabel;
    QwtCounter *sfl2PPt1YDSpin;
    QGroupBox *sfl2PPt2Group;
    QGridLayout *gridLayout_59;
    QGridLayout *gridLayout_9;
    QLabel *sfl2PPt2XLabel;
    QwtCounter *sfl2PPt2XDSpin;
    QLabel *sfl2PPt2YLabel;
    QwtCounter *sfl2PPt2YDSpin;
    QWidget *sfl2PLMTab;
    QGridLayout *gridLayout_100;
    QGridLayout *gridLayout_3;
    QLabel *sfl2PLMSlpLabel;
    QwtCounter *sfl2PLMSlpDSpin;
    QLabel *sfl2PLMIntLabel;
    QwtCounter *sfl2PLMIntDSpin;
    QSpacerItem *horizontalSpacer_23;
    QSpacerItem *verticalSpacer_30;
    QWidget *LThreeParameter;
    QGridLayout *gridLayout_86;
    QSpacerItem *verticalSpacer_29;
    QSpacerItem *horizontalSpacer_20;
    QTabWidget *sfl3PTab;
    QWidget *sfl3PPtsTab;
    QGridLayout *gridLayout_36;
    QGridLayout *gridLayout_35;
    QGroupBox *sfl3PPt1Group;
    QGridLayout *gridLayout_7;
    QGridLayout *gridLayout_5;
    QLabel *sfl3PPt1XLabel;
    QwtCounter *sfl3PPt1XDSpin;
    QLabel *sfl3PPt1YLabel;
    QwtCounter *sfl3PPt1YDSpin;
    QGroupBox *sfl3PPt2Group;
    QGridLayout *gridLayout_34;
    QGridLayout *gridLayout_4;
    QLabel *sfl3PPt2XLabel;
    QwtCounter *sfl3PPt2XDSpin;
    QLabel *sfl3PPt2YLabel;
    QwtCounter *sfl3PPt2YDSpin;
    QLabel *sfl3PPtsDfLabel;
    QwtCounter *sfl3PPtsDfDSpin;
    QWidget *sfl3PLMTab;
    QGridLayout *gridLayout_52;
    QGridLayout *gridLayout_25;
    QLabel *sfl3PLMSlpLayer;
    QwtCounter *sfl3PLMSlpDSpin;
    QLabel *sfl3PLMIntLabel;
    QwtCounter *sfl3PLMIntDSpin;
    QLabel *sfl3PLMDfLabel;
    QwtCounter *sfl3PLMDfDSpin;
    QSpacerItem *horizontalSpacer_21;
    QSpacerItem *verticalSpacer_28;
    QWidget *LPiecewiseLinear;
    QGridLayout *gridLayout_85;
    QSpacerItem *verticalSpacer_27;
    QSpacerItem *horizontalSpacer_18;
    QGridLayout *gridLayout_48;
    QHBoxLayout *horizontalLayout_4;
    QGridLayout *gridLayout_13;
    QLabel *sflPiecePtsLabel;
    QSpinBox *sflPiecePtsSpin;
    QRadioButton *sflPieceUseInterimRadio;
    QHBoxLayout *sflPieceHorizontalLayout;
    QTableWidget *sflPieceTableX;
    QTableWidget *sflPieceTableY;
    QSpacerItem *horizontalSpacer_19;
    QSpacerItem *verticalSpacer_26;
    QWidget *sfuTab;
    QGridLayout *gridLayout_63;
    QToolBox *sfuParamToolBox;
    QWidget *UParameterFree;
    QGridLayout *gridLayout_91;
    QSpacerItem *verticalSpacer_36;
    QSpacerItem *horizontalSpacer_28;
    QGridLayout *sfl0PLLayout_2;
    QComboBox *sfu0PCombo;
    QLabel *sfu0PLabel;
    QSpacerItem *horizontalSpacer_29;
    QSpacerItem *verticalSpacer_37;
    QWidget *UOneParameter;
    QGridLayout *gridLayout_93;
    QSpacerItem *verticalSpacer_39;
    QSpacerItem *horizontalSpacer_30;
    QGridLayout *gridLayout_92;
    QComboBox *sfu1PCombo;
    QwtCounter *sfu1PDSpin;
    QSpacerItem *horizontalSpacer_31;
    QSpacerItem *verticalSpacer_38;
    QWidget *UTwoParameter;
    QGridLayout *gridLayout_95;
    QSpacerItem *verticalSpacer_41;
    QSpacerItem *horizontalSpacer_32;
    QTabWidget *sfu2PTab;
    QWidget *sfu2P;
    QGridLayout *gridLayout_58;
    QVBoxLayout *verticalLayout_5;
    QGridLayout *sfu2PFunLayout;
    QLabel *sfu2PFunLabel;
    QComboBox *sfu2PFunCombo;
    QGridLayout *gridLayout_15;
    QGroupBox *sfu2PPt1Group;
    QGridLayout *gridLayout_29;
    QGridLayout *gridLayout_17;
    QLabel *sfu2PPt1XLabel;
    QwtCounter *sfu2PPt1XDSpin;
    QLabel *sfu2PPt1YLabel;
    QwtCounter *sfu2PPt1YDSpin;
    QGroupBox *sfu2PPt2Group;
    QGridLayout *gridLayout_16;
    QGridLayout *gridLayout_14;
    QLabel *sfu2PPt2XLabel;
    QwtCounter *sfu2PPt2XDSpin;
    QLabel *sfu2PPt2YLabel;
    QwtCounter *sfu2PPt2YDSpin;
    QWidget *sfl2PLMTab_2;
    QGridLayout *gridLayout_94;
    QGridLayout *gridLayout_18;
    QLabel *sfu2PLMSlpLabel;
    QwtCounter *sfu2PLMSlpDSpin;
    QLabel *sfu2PLMIntLabel;
    QwtCounter *sfu2PLMIntDSpin;
    QSpacerItem *horizontalSpacer_33;
    QSpacerItem *verticalSpacer_40;
    QWidget *UThreeParameter;
    QGridLayout *gridLayout_96;
    QSpacerItem *verticalSpacer_43;
    QSpacerItem *horizontalSpacer_34;
    QTabWidget *sfu3PTab;
    QWidget *sfu3PPts;
    QGridLayout *gridLayout_20;
    QGridLayout *gridLayout_19;
    QGroupBox *sfu3PPt1Group;
    QGridLayout *gridLayout_50;
    QGridLayout *gridLayout_21;
    QLabel *sfu3PPt1XLabel;
    QwtCounter *sfu3PPt1XDSpin;
    QLabel *sfu3PPt1YLabel;
    QwtCounter *sfu3PPt1YDSpin;
    QGroupBox *sfu3PPt2Group;
    QGridLayout *gridLayout_49;
    QGridLayout *gridLayout_22;
    QLabel *sfu3PPt2XLabel;
    QwtCounter *sfu3PPt2XDSpin;
    QLabel *sfu3PPt2YLabel;
    QwtCounter *sfu3PPt2YDSpin;
    QLabel *sfu3PPtsDfLabel;
    QwtCounter *sfu3PPtsDfDSpin;
    QWidget *sfu3PLMTab;
    QGridLayout *gridLayout_51;
    QGridLayout *gridLayout_28;
    QLabel *sfu3PLMSlpLabel;
    QwtCounter *sfu3PLMSlpDSpin;
    QLabel *sfu3PLMIntLabel;
    QwtCounter *sfu3PLMIntDSpin;
    QLabel *sfu3PLMDfLabel;
    QwtCounter *sfu3PLMDfDSpin;
    QSpacerItem *horizontalSpacer_35;
    QSpacerItem *verticalSpacer_42;
    QWidget *UPiecewiseLinear;
    QGridLayout *gridLayout_97;
    QSpacerItem *verticalSpacer_45;
    QSpacerItem *horizontalSpacer_36;
    QVBoxLayout *verticalLayout_3;
    QGridLayout *gridLayout_31;
    QGridLayout *gridLayout_23;
    QLabel *sfuPiecePtsLabel;
    QSpinBox *sfuPiecePtsSpin;
    QRadioButton *sfuPieceUseInterimRadio;
    QHBoxLayout *sfuPieceHorizontalLayout;
    QTableWidget *sfuPieceTableX;
    QTableWidget *sfuPieceTableY;
    QSpacerItem *horizontalSpacer_37;
    QSpacerItem *verticalSpacer_44;
    QVBoxLayout *verticalLayout_19;
    QGroupBox *tdTestingBox;
    QGridLayout *gridLayout_99;
    QGridLayout *gridLayout_104;
    QVBoxLayout *verticalLayout_20;
    QLabel *sflTestLabel;
    QComboBox *sflTestCombo;
    QSpacerItem *verticalSpacer_50;
    QVBoxLayout *verticalLayout_21;
    QLabel *sflLBSLabel;
    QComboBox *sflLBSCombo;
    QSpacerItem *verticalSpacer_51;
    QVBoxLayout *verticalLayout_22;
    QLabel *sflLBTLabel;
    QComboBox *sflLBTCombo;
    QSpacerItem *verticalSpacer_52;
    QWidget *AnalysisPage;
    QGridLayout *gridLayout_81;
    QTabWidget *analysisTab;
    QWidget *epss;
    QGridLayout *gridLayout_84;
    QSpacerItem *verticalSpacer_20;
    QVBoxLayout *verticalLayout_2;
    QGroupBox *anlErrorPowerSampleGroup;
    QGridLayout *gridLayout_79;
    QGridLayout *gridLayout_78;
    QLabel *anlErrorLabel;
    QwtCounter *anlErrorDSpin;
    QLabel *anlPowerLabel;
    QwtCounter *anlPowerDSpin;
    QSpacerItem *verticalSpacer_18;
    QGroupBox *analSampleSizeGroup;
    QGridLayout *gridLayout_77;
    QGridLayout *gridLayout_8;
    QLabel *anlMaxSampleSizeLabel;
    QSpinBox *anlMaxSampleSizeSpin;
    QSpacerItem *horizontalSpacer_12;
    QTableWidget *anlSampleSizeTable;
    QRadioButton *anlLockTimesRadio;
    QSpacerItem *horizontalSpacer_17;
    QSpacerItem *horizontalSpacer_7;
    QSpacerItem *verticalSpacer_25;
    QSpacerItem *horizontalSpacer_16;
    QGroupBox *groupBox_4;
    QGridLayout *gridLayout_80;
    QGridLayout *gridLayout_83;
    QwtCounter *anlMaxnIPlanDSpin;
    QSpacerItem *horizontalSpacer_8;
    QSpacerItem *verticalSpacer_21;
    QSpacerItem *verticalSpacer_24;
    QWidget *SimulationPage;
    QGridLayout *gridLayout_53;
    QSpacerItem *verticalSpacer_23;
    QSpacerItem *horizontalSpacer_14;
    QLabel *label_3;
    QSpacerItem *horizontalSpacer_15;
    QSpacerItem *verticalSpacer_22;
    QWidget *opEdit;
    QVBoxLayout *verticalLayout_11;
    QSpacerItem *verticalSpacer_6;
    QGroupBox *groupBox_2;
    QGridLayout *gridLayout_26;
    QHBoxLayout *horizontalLayout_7;
    QLabel *label_2;
    QComboBox *opTypeCombo;
    QSpacerItem *horizontalSpacer;
    QGridLayout *gridLayout_24;
    QLabel *opPlotRenderLabel;
    QComboBox *opPlotRenderCombo;
    QSpacerItem *verticalSpacer_5;
    QGroupBox *opLabelsGroup;
    QGridLayout *gridLayout_44;
    QGridLayout *gridLayout_38;
    QLabel *opTitleLabel;
    QLineEdit *opTitleLine;
    QLabel *opXLabelLabel;
    QLineEdit *opXLabelLine;
    QLabel *opYLabelLeftLabel;
    QLineEdit *opYLabelLeftLine;
    QSpacerItem *verticalSpacer_2;
    QHBoxLayout *horizontalLayout_5;
    QGroupBox *opLine1Group;
    QGridLayout *gridLayout_42;
    QGridLayout *gridLayout_43;
    QLabel *opLine1WidthLabel;
    QSpinBox *opLine1WidthSpin;
    QLabel *opLine1ColorLabel;
    QComboBox *opLine1ColorCombo;
    QLabel *opLine1TypeLabel;
    QComboBox *opLine1TypeCombo;
    QSpinBox *opLine1SymDigitsSpin;
    QLabel *opLine1SymDigitsLabel;
    QSpacerItem *horizontalSpacer_6;
    QGroupBox *opLine2Group;
    QGridLayout *gridLayout_45;
    QGridLayout *gridLayout_40;
    QLabel *opLine2WidthLabel;
    QSpinBox *opLine2WidthSpin;
    QLabel *opLine2ColorLabel;
    QComboBox *opLine2ColorCombo;
    QLabel *opLine2TypeLabel;
    QComboBox *opLine2TypeCombo;
    QSpinBox *opLine2SymDigitsSpin;
    QLabel *opLine2SymDigitsLabel;
    QSpacerItem *verticalSpacer_7;
    QTabWidget *outputTab;
    QWidget *outTextTab;
    QGridLayout *gridLayout;
    QTextEdit *otEdit;
    QWidget *outPlotTab;
    QGridLayout *gridLayout_76;
    QVBoxLayout *outputPlotVLayout;
    QHBoxLayout *outputPlotHComboLayout;
    QLabel *outputPlotTypeLabel;
    QComboBox *outputPlotTypeCombo;
    QSpacerItem *horizontalSpacer_22;
    QLabel *outputPlotRenderLabel;
    QComboBox *outputPlotRenderCombo;
    QHBoxLayout *outputPlotHFrameLayout;
    QLabel *outPlot;
    QMenuBar *menuBar;
    QMenu *menuDesign;
    QMenu *menuHelp;
    QMenu *menuFile;
    QMenu *menuGraph;
    QStatusBar *statusBar;
    QToolBar *fileToolbar;
    QToolBar *designToolbar;
    QToolBar *outputToolbar;
    QToolBar *helpToolbar;

    void setupUi(QMainWindow *gsDesign)
    {
        if (gsDesign->objectName().isEmpty())
            gsDesign->setObjectName(QString::fromUtf8("gsDesign"));
        gsDesign->resize(1338, 737);
        QFont font;
        font.setStrikeOut(false);
        font.setKerning(true);
        gsDesign->setFont(font);
        toolbarActionSaveDesign = new QAction(gsDesign);
        toolbarActionSaveDesign->setObjectName(QString::fromUtf8("toolbarActionSaveDesign"));
        QIcon icon;
        icon.addFile(QString::fromUtf8(":/toolbar/images/toolbar/fileSave.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionSaveDesign->setIcon(icon);
        menuActionLoadDesign = new QAction(gsDesign);
        menuActionLoadDesign->setObjectName(QString::fromUtf8("menuActionLoadDesign"));
        toolbarActionLoadDesign = new QAction(gsDesign);
        toolbarActionLoadDesign->setObjectName(QString::fromUtf8("toolbarActionLoadDesign"));
        QIcon icon1;
        icon1.addFile(QString::fromUtf8(":/toolbar/images/toolbar/designLoad.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionLoadDesign->setIcon(icon1);
        toolbarActionNewDesign = new QAction(gsDesign);
        toolbarActionNewDesign->setObjectName(QString::fromUtf8("toolbarActionNewDesign"));
        QIcon icon2;
        icon2.addFile(QString::fromUtf8(":/toolbar/images/toolbar/designNew.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionNewDesign->setIcon(icon2);
        toolbarActionNewDesign->setIconVisibleInMenu(true);
        toolbarActionRunDesign = new QAction(gsDesign);
        toolbarActionRunDesign->setObjectName(QString::fromUtf8("toolbarActionRunDesign"));
        QIcon icon3;
        icon3.addFile(QString::fromUtf8(":/toolbar/images/toolbar/designExecute.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionRunDesign->setIcon(icon3);
        menuActionOpenManual = new QAction(gsDesign);
        menuActionOpenManual->setObjectName(QString::fromUtf8("menuActionOpenManual"));
        menuActionContextHelp = new QAction(gsDesign);
        menuActionContextHelp->setObjectName(QString::fromUtf8("menuActionContextHelp"));
        menuActionAbout = new QAction(gsDesign);
        menuActionAbout->setObjectName(QString::fromUtf8("menuActionAbout"));
        toolbarActionContextHelp = new QAction(gsDesign);
        toolbarActionContextHelp->setObjectName(QString::fromUtf8("toolbarActionContextHelp"));
        toolbarActionContextHelp->setCheckable(true);
        QIcon icon4;
        icon4.addFile(QString::fromUtf8(":/toolbar/images/toolbar/help.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionContextHelp->setIcon(icon4);
        menuActionDefaultDesign = new QAction(gsDesign);
        menuActionDefaultDesign->setObjectName(QString::fromUtf8("menuActionDefaultDesign"));
        toolbarActionDeleteDesign = new QAction(gsDesign);
        toolbarActionDeleteDesign->setObjectName(QString::fromUtf8("toolbarActionDeleteDesign"));
        QIcon icon5;
        icon5.addFile(QString::fromUtf8(":/toolbar/images/toolbar/designDelete.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionDeleteDesign->setIcon(icon5);
        menuActionSaveDesign = new QAction(gsDesign);
        menuActionSaveDesign->setObjectName(QString::fromUtf8("menuActionSaveDesign"));
        menuActionSaveAsDesign = new QAction(gsDesign);
        menuActionSaveAsDesign->setObjectName(QString::fromUtf8("menuActionSaveAsDesign"));
        menuActionExportDesign = new QAction(gsDesign);
        menuActionExportDesign->setObjectName(QString::fromUtf8("menuActionExportDesign"));
        toolbarActionDefaultDesign = new QAction(gsDesign);
        toolbarActionDefaultDesign->setObjectName(QString::fromUtf8("toolbarActionDefaultDesign"));
        QIcon icon6;
        icon6.addFile(QString::fromUtf8(":/toolbar/images/toolbar/designDefault.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionDefaultDesign->setIcon(icon6);
        menuActionNewDesign = new QAction(gsDesign);
        menuActionNewDesign->setObjectName(QString::fromUtf8("menuActionNewDesign"));
        menuActionDeleteDesign = new QAction(gsDesign);
        menuActionDeleteDesign->setObjectName(QString::fromUtf8("menuActionDeleteDesign"));
        menuActionRunDesign = new QAction(gsDesign);
        menuActionRunDesign->setObjectName(QString::fromUtf8("menuActionRunDesign"));
        toolbarActionExportDesign = new QAction(gsDesign);
        toolbarActionExportDesign->setObjectName(QString::fromUtf8("toolbarActionExportDesign"));
        QIcon icon7;
        icon7.addFile(QString::fromUtf8(":/toolbar/images/toolbar/designExport.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionExportDesign->setIcon(icon7);
        menuActionEditPlot = new QAction(gsDesign);
        menuActionEditPlot->setObjectName(QString::fromUtf8("menuActionEditPlot"));
        menuActionExportPlot = new QAction(gsDesign);
        menuActionExportPlot->setObjectName(QString::fromUtf8("menuActionExportPlot"));
        toolbarActionEditPlot = new QAction(gsDesign);
        toolbarActionEditPlot->setObjectName(QString::fromUtf8("toolbarActionEditPlot"));
        toolbarActionEditPlot->setCheckable(true);
        QIcon icon8;
        icon8.addFile(QString::fromUtf8(":/toolbar/images/toolbar/edit.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionEditPlot->setIcon(icon8);
        toolbarActionExportPlot = new QAction(gsDesign);
        toolbarActionExportPlot->setObjectName(QString::fromUtf8("toolbarActionExportPlot"));
        QIcon icon9;
        icon9.addFile(QString::fromUtf8(":/toolbar/images/toolbar/plotExport.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionExportPlot->setIcon(icon9);
        menuActionChangeWorkingDirectory = new QAction(gsDesign);
        menuActionChangeWorkingDirectory->setObjectName(QString::fromUtf8("menuActionChangeWorkingDirectory"));
        menuActionExportAllDesigns = new QAction(gsDesign);
        menuActionExportAllDesigns->setObjectName(QString::fromUtf8("menuActionExportAllDesigns"));
        toolbarActionSetWorkingDirectory = new QAction(gsDesign);
        toolbarActionSetWorkingDirectory->setObjectName(QString::fromUtf8("toolbarActionSetWorkingDirectory"));
        QIcon icon10;
        icon10.addFile(QString::fromUtf8(":/toolbar/images/toolbar/home.png"), QSize(), QIcon::Normal, QIcon::Off);
        toolbarActionSetWorkingDirectory->setIcon(icon10);
        menuActionPlotDefaults = new QAction(gsDesign);
        menuActionPlotDefaults->setObjectName(QString::fromUtf8("menuActionPlotDefaults"));
        menuActionExit = new QAction(gsDesign);
        menuActionExit->setObjectName(QString::fromUtf8("menuActionExit"));
        menuActionAutoscalePlot = new QAction(gsDesign);
        menuActionAutoscalePlot->setObjectName(QString::fromUtf8("menuActionAutoscalePlot"));
        menuActionAutoscalePlot->setCheckable(true);
        gsDesignMainWidget = new QWidget(gsDesign);
        gsDesignMainWidget->setObjectName(QString::fromUtf8("gsDesignMainWidget"));
        layoutWidget = new QWidget(gsDesignMainWidget);
        layoutWidget->setObjectName(QString::fromUtf8("layoutWidget"));
        layoutWidget->setGeometry(QRect(0, 0, 1175, 624));
        gridLayout_61 = new QGridLayout(layoutWidget);
        gridLayout_61->setSpacing(6);
        gridLayout_61->setContentsMargins(11, 11, 11, 11);
        gridLayout_61->setObjectName(QString::fromUtf8("gridLayout_61"));
        gridLayout_61->setContentsMargins(0, 0, 0, 0);
        dnGroup = new QGroupBox(layoutWidget);
        dnGroup->setObjectName(QString::fromUtf8("dnGroup"));
        dnGroup->setMinimumSize(QSize(0, 69));
        dnGroup->setMaximumSize(QSize(737, 16777215));
        dnGroup->setAutoFillBackground(true);
        navLayoutWidget = new QWidget(dnGroup);
        navLayoutWidget->setObjectName(QString::fromUtf8("navLayoutWidget"));
        navLayoutWidget->setGeometry(QRect(3, 10, 731, 55));
        verticalLayout = new QVBoxLayout(navLayoutWidget);
        verticalLayout->setSpacing(6);
        verticalLayout->setContentsMargins(11, 11, 11, 11);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setSizeConstraint(QLayout::SetMaximumSize);
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        dnModeCombo = new QComboBox(navLayoutWidget);
        dnModeCombo->setObjectName(QString::fromUtf8("dnModeCombo"));
        QSizePolicy sizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(dnModeCombo->sizePolicy().hasHeightForWidth());
        dnModeCombo->setSizePolicy(sizePolicy);

        horizontalLayout->addWidget(dnModeCombo);

        dnNameCombo = new QComboBox(navLayoutWidget);
        dnNameCombo->setObjectName(QString::fromUtf8("dnNameCombo"));
        sizePolicy.setHeightForWidth(dnNameCombo->sizePolicy().hasHeightForWidth());
        dnNameCombo->setSizePolicy(sizePolicy);
        dnNameCombo->setMinimumSize(QSize(150, 0));
        dnNameCombo->setLayoutDirection(Qt::LeftToRight);
        dnNameCombo->setAutoFillBackground(true);
        dnNameCombo->setEditable(true);
        dnNameCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
        dnNameCombo->setSizeAdjustPolicy(QComboBox::AdjustToContentsOnFirstShow);

        horizontalLayout->addWidget(dnNameCombo);

        horizontalSpacer_38 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout->addItem(horizontalSpacer_38);


        verticalLayout->addLayout(horizontalLayout);

        dnDescCombo = new QComboBox(navLayoutWidget);
        dnDescCombo->setObjectName(QString::fromUtf8("dnDescCombo"));
        dnDescCombo->setContextMenuPolicy(Qt::DefaultContextMenu);
        dnDescCombo->setEditable(true);
        dnDescCombo->setInsertPolicy(QComboBox::InsertAtCurrent);
        dnDescCombo->setSizeAdjustPolicy(QComboBox::AdjustToMinimumContentsLengthWithIcon);

        verticalLayout->addWidget(dnDescCombo);


        gridLayout_61->addWidget(dnGroup, 0, 0, 1, 1);

        modeStack = new QStackedWidget(layoutWidget);
        modeStack->setObjectName(QString::fromUtf8("modeStack"));
        modeStack->setFrameShape(QFrame::StyledPanel);
        DesignPage = new QWidget();
        DesignPage->setObjectName(QString::fromUtf8("DesignPage"));
        gridLayout_65 = new QGridLayout(DesignPage);
        gridLayout_65->setSpacing(6);
        gridLayout_65->setContentsMargins(11, 11, 11, 11);
        gridLayout_65->setObjectName(QString::fromUtf8("gridLayout_65"));
        designTab = new QTabWidget(DesignPage);
        designTab->setObjectName(QString::fromUtf8("designTab"));
        designTab->setUsesScrollButtons(false);
        eptTab = new QWidget();
        eptTab->setObjectName(QString::fromUtf8("eptTab"));
        gridLayout_74 = new QGridLayout(eptTab);
        gridLayout_74->setSpacing(6);
        gridLayout_74->setContentsMargins(11, 11, 11, 11);
        gridLayout_74->setObjectName(QString::fromUtf8("gridLayout_74"));
        verticalSpacer_15 = new QSpacerItem(337, 24, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_74->addItem(verticalSpacer_15, 0, 1, 1, 1);

        horizontalSpacer_9 = new QSpacerItem(107, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_74->addItem(horizontalSpacer_9, 1, 0, 1, 1);

        verticalLayout_9 = new QVBoxLayout();
        verticalLayout_9->setSpacing(6);
        verticalLayout_9->setObjectName(QString::fromUtf8("verticalLayout_9"));
        eptErrorPowerGroup = new QGroupBox(eptTab);
        eptErrorPowerGroup->setObjectName(QString::fromUtf8("eptErrorPowerGroup"));
        eptErrorPowerGroup->setMaximumSize(QSize(340, 16777215));
        gridLayout_66 = new QGridLayout(eptErrorPowerGroup);
        gridLayout_66->setSpacing(6);
        gridLayout_66->setContentsMargins(3, 3, 3, 3);
        gridLayout_66->setObjectName(QString::fromUtf8("gridLayout_66"));
        gridLayout_39 = new QGridLayout();
        gridLayout_39->setSpacing(6);
        gridLayout_39->setObjectName(QString::fromUtf8("gridLayout_39"));
        eptErrorLabel = new QLabel(eptErrorPowerGroup);
        eptErrorLabel->setObjectName(QString::fromUtf8("eptErrorLabel"));
        eptErrorLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_39->addWidget(eptErrorLabel, 0, 0, 1, 1);

        eptErrorDSpin = new QwtCounter(eptErrorPowerGroup);
        eptErrorDSpin->setObjectName(QString::fromUtf8("eptErrorDSpin"));
        QSizePolicy sizePolicy1(QSizePolicy::Preferred, QSizePolicy::Fixed);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(eptErrorDSpin->sizePolicy().hasHeightForWidth());
        eptErrorDSpin->setSizePolicy(sizePolicy1);
        eptErrorDSpin->setMaximumSize(QSize(150, 16777215));
        eptErrorDSpin->setProperty("numButtons", QVariant(1));
        eptErrorDSpin->setProperty("basicstep", QVariant(0.1));
        eptErrorDSpin->setProperty("maxValue", QVariant(100));
        eptErrorDSpin->setProperty("value", QVariant(2.5));
        eptErrorDSpin->setProperty("decimals", QVariant(1));
        eptErrorDSpin->setProperty("maximum", QVariant(100));
        eptErrorDSpin->setProperty("singleStep", QVariant(0.1));

        gridLayout_39->addWidget(eptErrorDSpin, 0, 1, 1, 1);

        eptPowerLabel = new QLabel(eptErrorPowerGroup);
        eptPowerLabel->setObjectName(QString::fromUtf8("eptPowerLabel"));
        eptPowerLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_39->addWidget(eptPowerLabel, 2, 0, 1, 1);

        eptPowerDSpin = new QwtCounter(eptErrorPowerGroup);
        eptPowerDSpin->setObjectName(QString::fromUtf8("eptPowerDSpin"));
        sizePolicy1.setHeightForWidth(eptPowerDSpin->sizePolicy().hasHeightForWidth());
        eptPowerDSpin->setSizePolicy(sizePolicy1);
        eptPowerDSpin->setMaximumSize(QSize(150, 16777215));
        eptPowerDSpin->setLayoutDirection(Qt::LeftToRight);
        eptPowerDSpin->setProperty("numButtons", QVariant(1));
        eptPowerDSpin->setProperty("basicstep", QVariant(0.5));
        eptPowerDSpin->setProperty("maxValue", QVariant(100));
        eptPowerDSpin->setProperty("value", QVariant(90));
        eptPowerDSpin->setProperty("decimals", QVariant(1));
        eptPowerDSpin->setProperty("singleStep", QVariant(0.5));

        gridLayout_39->addWidget(eptPowerDSpin, 2, 1, 1, 1);

        eptPowerHSlider = new QwtSlider(eptErrorPowerGroup);
        eptPowerHSlider->setObjectName(QString::fromUtf8("eptPowerHSlider"));
        QSizePolicy sizePolicy2(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy2.setHorizontalStretch(0);
        sizePolicy2.setVerticalStretch(0);
        sizePolicy2.setHeightForWidth(eptPowerHSlider->sizePolicy().hasHeightForWidth());
        eptPowerHSlider->setSizePolicy(sizePolicy2);

        gridLayout_39->addWidget(eptPowerHSlider, 3, 0, 1, 2);

        eptErrorHSlider = new QwtSlider(eptErrorPowerGroup);
        eptErrorHSlider->setObjectName(QString::fromUtf8("eptErrorHSlider"));
        sizePolicy2.setHeightForWidth(eptErrorHSlider->sizePolicy().hasHeightForWidth());
        eptErrorHSlider->setSizePolicy(sizePolicy2);

        gridLayout_39->addWidget(eptErrorHSlider, 1, 0, 1, 2);


        gridLayout_66->addLayout(gridLayout_39, 0, 0, 1, 1);


        verticalLayout_9->addWidget(eptErrorPowerGroup);

        verticalSpacer_14 = new QSpacerItem(20, 33, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_9->addItem(verticalSpacer_14);

        tdTimingGroup = new QGroupBox(eptTab);
        tdTimingGroup->setObjectName(QString::fromUtf8("tdTimingGroup"));
        tdTimingGroup->setMaximumSize(QSize(340, 16777215));
        gridLayout_41 = new QGridLayout(tdTimingGroup);
        gridLayout_41->setSpacing(6);
        gridLayout_41->setContentsMargins(3, 3, 3, 3);
        gridLayout_41->setObjectName(QString::fromUtf8("gridLayout_41"));
        gridLayout_2 = new QGridLayout();
        gridLayout_2->setSpacing(6);
        gridLayout_2->setObjectName(QString::fromUtf8("gridLayout_2"));
        eptIntervalsLabel = new QLabel(tdTimingGroup);
        eptIntervalsLabel->setObjectName(QString::fromUtf8("eptIntervalsLabel"));
        eptIntervalsLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_2->addWidget(eptIntervalsLabel, 0, 0, 1, 1);

        eptIntervalsSpin = new QSpinBox(tdTimingGroup);
        eptIntervalsSpin->setObjectName(QString::fromUtf8("eptIntervalsSpin"));
        sizePolicy1.setHeightForWidth(eptIntervalsSpin->sizePolicy().hasHeightForWidth());
        eptIntervalsSpin->setSizePolicy(sizePolicy1);
        eptIntervalsSpin->setMaximumSize(QSize(150, 16777215));
        eptIntervalsSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        eptIntervalsSpin->setMinimum(1);
        eptIntervalsSpin->setValue(2);

        gridLayout_2->addWidget(eptIntervalsSpin, 0, 1, 1, 1);

        eptSpacingLabel = new QLabel(tdTimingGroup);
        eptSpacingLabel->setObjectName(QString::fromUtf8("eptSpacingLabel"));
        eptSpacingLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_2->addWidget(eptSpacingLabel, 1, 0, 1, 1);

        eptSpacingCombo = new QComboBox(tdTimingGroup);
        eptSpacingCombo->setObjectName(QString::fromUtf8("eptSpacingCombo"));

        gridLayout_2->addWidget(eptSpacingCombo, 1, 1, 1, 1);

        eptSpacingLabel_2 = new QLabel(tdTimingGroup);
        eptSpacingLabel_2->setObjectName(QString::fromUtf8("eptSpacingLabel_2"));
        eptSpacingLabel_2->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop);

        gridLayout_2->addWidget(eptSpacingLabel_2, 2, 0, 1, 1);

        eptTimingTable = new QTableWidget(tdTimingGroup);
        if (eptTimingTable->columnCount() < 1)
            eptTimingTable->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem = new QTableWidgetItem();
        eptTimingTable->setHorizontalHeaderItem(0, __qtablewidgetitem);
        if (eptTimingTable->rowCount() < 3)
            eptTimingTable->setRowCount(3);
        QTableWidgetItem *__qtablewidgetitem1 = new QTableWidgetItem();
        __qtablewidgetitem1->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        eptTimingTable->setItem(0, 0, __qtablewidgetitem1);
        QTableWidgetItem *__qtablewidgetitem2 = new QTableWidgetItem();
        __qtablewidgetitem2->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        eptTimingTable->setItem(1, 0, __qtablewidgetitem2);
        QTableWidgetItem *__qtablewidgetitem3 = new QTableWidgetItem();
        __qtablewidgetitem3->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        eptTimingTable->setItem(2, 0, __qtablewidgetitem3);
        eptTimingTable->setObjectName(QString::fromUtf8("eptTimingTable"));
        QSizePolicy sizePolicy3(QSizePolicy::Preferred, QSizePolicy::Expanding);
        sizePolicy3.setHorizontalStretch(0);
        sizePolicy3.setVerticalStretch(0);
        sizePolicy3.setHeightForWidth(eptTimingTable->sizePolicy().hasHeightForWidth());
        eptTimingTable->setSizePolicy(sizePolicy3);
        eptTimingTable->setMinimumSize(QSize(0, 0));
        eptTimingTable->setMaximumSize(QSize(150, 16777215));
        eptTimingTable->setBaseSize(QSize(0, 0));
        QFont font1;
        font1.setKerning(false);
        eptTimingTable->setFont(font1);
        eptTimingTable->setAutoFillBackground(true);
        eptTimingTable->setProperty("showDropIndicator", QVariant(true));
        eptTimingTable->setSortingEnabled(false);
        eptTimingTable->setRowCount(3);
        eptTimingTable->setColumnCount(1);
        eptTimingTable->horizontalHeader()->setCascadingSectionResizes(true);
        eptTimingTable->horizontalHeader()->setDefaultSectionSize(167);
        eptTimingTable->horizontalHeader()->setStretchLastSection(true);
        eptTimingTable->verticalHeader()->setCascadingSectionResizes(true);
        eptTimingTable->verticalHeader()->setStretchLastSection(false);

        gridLayout_2->addWidget(eptTimingTable, 2, 1, 1, 1);


        gridLayout_41->addLayout(gridLayout_2, 0, 0, 1, 1);


        verticalLayout_9->addWidget(tdTimingGroup);


        gridLayout_74->addLayout(verticalLayout_9, 1, 1, 1, 1);

        horizontalSpacer_10 = new QSpacerItem(107, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_74->addItem(horizontalSpacer_10, 1, 2, 1, 1);

        verticalSpacer_16 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_74->addItem(verticalSpacer_16, 2, 1, 1, 1);

        designTab->addTab(eptTab, QString());
        ss = new QWidget();
        ss->setObjectName(QString::fromUtf8("ss"));
        gridLayout_75 = new QGridLayout(ss);
        gridLayout_75->setSpacing(6);
        gridLayout_75->setContentsMargins(11, 11, 11, 11);
        gridLayout_75->setObjectName(QString::fromUtf8("gridLayout_75"));
        sampleSizeTab = new QTabWidget(ss);
        sampleSizeTab->setObjectName(QString::fromUtf8("sampleSizeTab"));
        ssUserTab = new QWidget();
        ssUserTab->setObjectName(QString::fromUtf8("ssUserTab"));
        gridLayout_82 = new QGridLayout(ssUserTab);
        gridLayout_82->setSpacing(6);
        gridLayout_82->setContentsMargins(11, 11, 11, 11);
        gridLayout_82->setObjectName(QString::fromUtf8("gridLayout_82"));
        verticalSpacer_17 = new QSpacerItem(20, 180, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_82->addItem(verticalSpacer_17, 0, 1, 1, 1);

        horizontalSpacer_11 = new QSpacerItem(134, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_82->addItem(horizontalSpacer_11, 1, 0, 1, 1);

        gridLayout_6 = new QGridLayout();
        gridLayout_6->setSpacing(6);
        gridLayout_6->setObjectName(QString::fromUtf8("gridLayout_6"));
        ssUserFixedLabel = new QLabel(ssUserTab);
        ssUserFixedLabel->setObjectName(QString::fromUtf8("ssUserFixedLabel"));

        gridLayout_6->addWidget(ssUserFixedLabel, 0, 0, 1, 1);

        ssUserFixedSpin = new QSpinBox(ssUserTab);
        ssUserFixedSpin->setObjectName(QString::fromUtf8("ssUserFixedSpin"));
        ssUserFixedSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        ssUserFixedSpin->setMaximum(99999);

        gridLayout_6->addWidget(ssUserFixedSpin, 0, 1, 1, 1);


        gridLayout_82->addLayout(gridLayout_6, 1, 1, 1, 1);

        horizontalSpacer_13 = new QSpacerItem(133, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_82->addItem(horizontalSpacer_13, 1, 2, 1, 1);

        verticalSpacer_19 = new QSpacerItem(20, 180, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_82->addItem(verticalSpacer_19, 2, 1, 1, 1);

        sampleSizeTab->addTab(ssUserTab, QString());
        ssBinTab = new QWidget();
        ssBinTab->setObjectName(QString::fromUtf8("ssBinTab"));
        gridLayout_98 = new QGridLayout(ssBinTab);
        gridLayout_98->setSpacing(6);
        gridLayout_98->setContentsMargins(11, 11, 11, 11);
        gridLayout_98->setObjectName(QString::fromUtf8("gridLayout_98"));
        ssBinEventGroup = new QGroupBox(ssBinTab);
        ssBinEventGroup->setObjectName(QString::fromUtf8("ssBinEventGroup"));
        sizePolicy1.setHeightForWidth(ssBinEventGroup->sizePolicy().hasHeightForWidth());
        ssBinEventGroup->setSizePolicy(sizePolicy1);
        gridLayout_71 = new QGridLayout(ssBinEventGroup);
        gridLayout_71->setSpacing(6);
        gridLayout_71->setContentsMargins(3, 3, 3, 3);
        gridLayout_71->setObjectName(QString::fromUtf8("gridLayout_71"));
        gridLayout_70 = new QGridLayout();
        gridLayout_70->setSpacing(6);
        gridLayout_70->setObjectName(QString::fromUtf8("gridLayout_70"));
        ssBinRatioLabel = new QLabel(ssBinEventGroup);
        ssBinRatioLabel->setObjectName(QString::fromUtf8("ssBinRatioLabel"));
        ssBinRatioLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_70->addWidget(ssBinRatioLabel, 0, 0, 1, 1);

        ssBinRatioDSpin = new QwtCounter(ssBinEventGroup);
        ssBinRatioDSpin->setObjectName(QString::fromUtf8("ssBinRatioDSpin"));
        ssBinRatioDSpin->setProperty("numButtons", QVariant(1));
        ssBinRatioDSpin->setProperty("value", QVariant(1));
        ssBinRatioDSpin->setProperty("decimals", QVariant(4));

        gridLayout_70->addWidget(ssBinRatioDSpin, 0, 1, 1, 1);

        ssBinControlLabel = new QLabel(ssBinEventGroup);
        ssBinControlLabel->setObjectName(QString::fromUtf8("ssBinControlLabel"));
        ssBinControlLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_70->addWidget(ssBinControlLabel, 1, 0, 1, 1);

        ssBinControlDSpin = new QwtCounter(ssBinEventGroup);
        ssBinControlDSpin->setObjectName(QString::fromUtf8("ssBinControlDSpin"));
        ssBinControlDSpin->setProperty("numButtons", QVariant(1));
        ssBinControlDSpin->setProperty("value", QVariant(0.15));
        ssBinControlDSpin->setProperty("decimals", QVariant(4));
        ssBinControlDSpin->setProperty("maximum", QVariant(1));
        ssBinControlDSpin->setProperty("singleStep", QVariant(0.05));

        gridLayout_70->addWidget(ssBinControlDSpin, 1, 1, 1, 1);

        ssBinExpLabel = new QLabel(ssBinEventGroup);
        ssBinExpLabel->setObjectName(QString::fromUtf8("ssBinExpLabel"));
        ssBinExpLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_70->addWidget(ssBinExpLabel, 2, 0, 1, 1);

        ssBinExpDSpin = new QwtCounter(ssBinEventGroup);
        ssBinExpDSpin->setObjectName(QString::fromUtf8("ssBinExpDSpin"));
        ssBinExpDSpin->setProperty("numButtons", QVariant(1));
        ssBinExpDSpin->setProperty("value", QVariant(0.1));
        ssBinExpDSpin->setProperty("decimals", QVariant(4));
        ssBinExpDSpin->setProperty("maximum", QVariant(1));
        ssBinExpDSpin->setProperty("singleStep", QVariant(0.05));

        gridLayout_70->addWidget(ssBinExpDSpin, 2, 1, 1, 1);


        gridLayout_71->addLayout(gridLayout_70, 0, 0, 1, 1);


        gridLayout_98->addWidget(ssBinEventGroup, 0, 0, 1, 1);

        ssBinTestingGroup = new QGroupBox(ssBinTab);
        ssBinTestingGroup->setObjectName(QString::fromUtf8("ssBinTestingGroup"));
        ssBinTestingGroup->setMaximumSize(QSize(200, 16777215));
        gridLayout_69 = new QGridLayout(ssBinTestingGroup);
        gridLayout_69->setSpacing(6);
        gridLayout_69->setContentsMargins(3, 3, 3, 3);
        gridLayout_69->setObjectName(QString::fromUtf8("gridLayout_69"));
        ssBinSupCombo = new QComboBox(ssBinTestingGroup);
        ssBinSupCombo->setObjectName(QString::fromUtf8("ssBinSupCombo"));
        QSizePolicy sizePolicy4(QSizePolicy::Ignored, QSizePolicy::Fixed);
        sizePolicy4.setHorizontalStretch(0);
        sizePolicy4.setVerticalStretch(0);
        sizePolicy4.setHeightForWidth(ssBinSupCombo->sizePolicy().hasHeightForWidth());
        ssBinSupCombo->setSizePolicy(sizePolicy4);

        gridLayout_69->addWidget(ssBinSupCombo, 0, 0, 1, 1);

        gridLayout_37 = new QGridLayout();
        gridLayout_37->setSpacing(6);
        gridLayout_37->setObjectName(QString::fromUtf8("gridLayout_37"));
        ssBinDeltaLabel = new QLabel(ssBinTestingGroup);
        ssBinDeltaLabel->setObjectName(QString::fromUtf8("ssBinDeltaLabel"));
        ssBinDeltaLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_37->addWidget(ssBinDeltaLabel, 0, 0, 1, 1);

        ssBinDeltaDSpin = new QwtCounter(ssBinTestingGroup);
        ssBinDeltaDSpin->setObjectName(QString::fromUtf8("ssBinDeltaDSpin"));
        ssBinDeltaDSpin->setEnabled(false);
        QSizePolicy sizePolicy5(QSizePolicy::MinimumExpanding, QSizePolicy::Fixed);
        sizePolicy5.setHorizontalStretch(0);
        sizePolicy5.setVerticalStretch(0);
        sizePolicy5.setHeightForWidth(ssBinDeltaDSpin->sizePolicy().hasHeightForWidth());
        ssBinDeltaDSpin->setSizePolicy(sizePolicy5);
        ssBinDeltaDSpin->setProperty("numButtons", QVariant(1));
        ssBinDeltaDSpin->setProperty("decimals", QVariant(4));

        gridLayout_37->addWidget(ssBinDeltaDSpin, 0, 2, 1, 1);


        gridLayout_69->addLayout(gridLayout_37, 1, 0, 1, 1);


        gridLayout_98->addWidget(ssBinTestingGroup, 2, 0, 1, 1);

        groupBox_3 = new QGroupBox(ssBinTab);
        groupBox_3->setObjectName(QString::fromUtf8("groupBox_3"));
        groupBox_3->setMaximumSize(QSize(200, 16777215));
        gridLayout_67 = new QGridLayout(groupBox_3);
        gridLayout_67->setSpacing(6);
        gridLayout_67->setContentsMargins(3, 3, 3, 3);
        gridLayout_67->setObjectName(QString::fromUtf8("gridLayout_67"));
        gridLayout_32 = new QGridLayout();
        gridLayout_32->setSpacing(6);
        gridLayout_32->setObjectName(QString::fromUtf8("gridLayout_32"));
        ssBinSSLabel = new QLabel(groupBox_3);
        ssBinSSLabel->setObjectName(QString::fromUtf8("ssBinSSLabel"));
        QFont font2;
        font2.setItalic(true);
        ssBinSSLabel->setFont(font2);

        gridLayout_32->addWidget(ssBinSSLabel, 0, 0, 1, 1);

        ssBinFixedSpin = new QSpinBox(groupBox_3);
        ssBinFixedSpin->setObjectName(QString::fromUtf8("ssBinFixedSpin"));
        ssBinFixedSpin->setEnabled(true);
        ssBinFixedSpin->setAutoFillBackground(true);
        ssBinFixedSpin->setAlignment(Qt::AlignCenter);
        ssBinFixedSpin->setReadOnly(true);
        ssBinFixedSpin->setButtonSymbols(QAbstractSpinBox::NoButtons);

        gridLayout_32->addWidget(ssBinFixedSpin, 0, 1, 1, 1);


        gridLayout_67->addLayout(gridLayout_32, 0, 0, 1, 1);


        gridLayout_98->addWidget(groupBox_3, 2, 2, 1, 1);

        horizontalSpacer_2 = new QSpacerItem(134, 112, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_98->addItem(horizontalSpacer_2, 0, 1, 1, 2);

        verticalSpacer_9 = new QSpacerItem(134, 174, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_98->addItem(verticalSpacer_9, 1, 2, 1, 1);

        horizontalSpacer_3 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_98->addItem(horizontalSpacer_3, 2, 1, 1, 1);

        verticalSpacer_8 = new QSpacerItem(219, 174, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_98->addItem(verticalSpacer_8, 1, 0, 1, 1);

        sampleSizeTab->addTab(ssBinTab, QString());
        ssTETab = new QWidget();
        ssTETab->setObjectName(QString::fromUtf8("ssTETab"));
        gridLayout_73 = new QGridLayout(ssTETab);
        gridLayout_73->setSpacing(6);
        gridLayout_73->setContentsMargins(11, 11, 11, 11);
        gridLayout_73->setObjectName(QString::fromUtf8("gridLayout_73"));
        horizontalSpacer_4 = new QSpacerItem(60, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_73->addItem(horizontalSpacer_4, 0, 1, 1, 1);

        ssTEAccrualGroup = new QGroupBox(ssTETab);
        ssTEAccrualGroup->setObjectName(QString::fromUtf8("ssTEAccrualGroup"));
        gridLayout_72 = new QGridLayout(ssTEAccrualGroup);
        gridLayout_72->setSpacing(6);
        gridLayout_72->setContentsMargins(3, 3, 3, 3);
        gridLayout_72->setObjectName(QString::fromUtf8("gridLayout_72"));
        ssTEAccrualLayout = new QVBoxLayout();
        ssTEAccrualLayout->setSpacing(6);
        ssTEAccrualLayout->setObjectName(QString::fromUtf8("ssTEAccrualLayout"));
        ssTEAccrualCombo = new QComboBox(ssTEAccrualGroup);
        ssTEAccrualCombo->setObjectName(QString::fromUtf8("ssTEAccrualCombo"));

        ssTEAccrualLayout->addWidget(ssTEAccrualCombo);

        ssTEGammaLayout = new QGridLayout();
        ssTEGammaLayout->setSpacing(6);
        ssTEGammaLayout->setObjectName(QString::fromUtf8("ssTEGammaLayout"));
        ssTEGammaLabel = new QLabel(ssTEAccrualGroup);
        ssTEGammaLabel->setObjectName(QString::fromUtf8("ssTEGammaLabel"));

        ssTEGammaLayout->addWidget(ssTEGammaLabel, 0, 0, 1, 1);

        ssTEGammaDSpin = new QwtCounter(ssTEAccrualGroup);
        ssTEGammaDSpin->setObjectName(QString::fromUtf8("ssTEGammaDSpin"));
        ssTEGammaDSpin->setProperty("numButtons", QVariant(1));

        ssTEGammaLayout->addWidget(ssTEGammaDSpin, 0, 1, 1, 1);


        ssTEAccrualLayout->addLayout(ssTEGammaLayout);


        gridLayout_72->addLayout(ssTEAccrualLayout, 0, 0, 1, 1);


        gridLayout_73->addWidget(ssTEAccrualGroup, 0, 2, 1, 1);

        verticalSpacer_11 = new QSpacerItem(20, 67, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_73->addItem(verticalSpacer_11, 2, 0, 1, 1);

        verticalSpacer_12 = new QSpacerItem(20, 135, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_73->addItem(verticalSpacer_12, 2, 2, 2, 1);

        ssTEOtherGroup = new QGroupBox(ssTETab);
        ssTEOtherGroup->setObjectName(QString::fromUtf8("ssTEOtherGroup"));
        gridLayout_54 = new QGridLayout(ssTEOtherGroup);
        gridLayout_54->setSpacing(6);
        gridLayout_54->setContentsMargins(3, 3, 3, 3);
        gridLayout_54->setObjectName(QString::fromUtf8("gridLayout_54"));
        gridLayout_46 = new QGridLayout();
        gridLayout_46->setSpacing(6);
        gridLayout_46->setObjectName(QString::fromUtf8("gridLayout_46"));
        ssTEAccrualLabel = new QLabel(ssTEOtherGroup);
        ssTEAccrualLabel->setObjectName(QString::fromUtf8("ssTEAccrualLabel"));

        gridLayout_46->addWidget(ssTEAccrualLabel, 0, 0, 1, 1);

        ssTEAccrualDSpin = new QwtCounter(ssTEOtherGroup);
        ssTEAccrualDSpin->setObjectName(QString::fromUtf8("ssTEAccrualDSpin"));
        ssTEAccrualDSpin->setProperty("numButtons", QVariant(1));
        ssTEAccrualDSpin->setProperty("maxValue", QVariant(1e+06));
        ssTEAccrualDSpin->setProperty("value", QVariant(18));

        gridLayout_46->addWidget(ssTEAccrualDSpin, 0, 1, 1, 1);

        ssTEFollowLabel = new QLabel(ssTEOtherGroup);
        ssTEFollowLabel->setObjectName(QString::fromUtf8("ssTEFollowLabel"));

        gridLayout_46->addWidget(ssTEFollowLabel, 1, 0, 1, 1);

        ssTEFollowDSpin = new QwtCounter(ssTEOtherGroup);
        ssTEFollowDSpin->setObjectName(QString::fromUtf8("ssTEFollowDSpin"));
        ssTEFollowDSpin->setProperty("numButtons", QVariant(1));
        ssTEFollowDSpin->setProperty("maxValue", QVariant(1e+06));
        ssTEFollowDSpin->setProperty("value", QVariant(12));

        gridLayout_46->addWidget(ssTEFollowDSpin, 1, 1, 1, 1);

        ssTERatioLabel = new QLabel(ssTEOtherGroup);
        ssTERatioLabel->setObjectName(QString::fromUtf8("ssTERatioLabel"));

        gridLayout_46->addWidget(ssTERatioLabel, 2, 0, 1, 1);

        ssTERatioDSpin = new QwtCounter(ssTEOtherGroup);
        ssTERatioDSpin->setObjectName(QString::fromUtf8("ssTERatioDSpin"));
        ssTERatioDSpin->setProperty("numButtons", QVariant(1));
        ssTERatioDSpin->setProperty("value", QVariant(1));

        gridLayout_46->addWidget(ssTERatioDSpin, 2, 1, 1, 1);

        ssTEHypLabel = new QLabel(ssTEOtherGroup);
        ssTEHypLabel->setObjectName(QString::fromUtf8("ssTEHypLabel"));

        gridLayout_46->addWidget(ssTEHypLabel, 3, 0, 1, 1);

        ssTEHypCombo = new QComboBox(ssTEOtherGroup);
        ssTEHypCombo->setObjectName(QString::fromUtf8("ssTEHypCombo"));

        gridLayout_46->addWidget(ssTEHypCombo, 3, 1, 1, 1);


        gridLayout_54->addLayout(gridLayout_46, 0, 0, 1, 1);


        gridLayout_73->addWidget(ssTEOtherGroup, 3, 0, 2, 1);

        horizontalSpacer_5 = new QSpacerItem(60, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_73->addItem(horizontalSpacer_5, 4, 1, 1, 1);

        groupBox = new QGroupBox(ssTETab);
        groupBox->setObjectName(QString::fromUtf8("groupBox"));
        gridLayout_57 = new QGridLayout(groupBox);
        gridLayout_57->setSpacing(6);
        gridLayout_57->setContentsMargins(3, 3, 3, 3);
        gridLayout_57->setObjectName(QString::fromUtf8("gridLayout_57"));
        gridLayout_56 = new QGridLayout();
        gridLayout_56->setSpacing(6);
        gridLayout_56->setObjectName(QString::fromUtf8("gridLayout_56"));
        ssTEFixedLabel = new QLabel(groupBox);
        ssTEFixedLabel->setObjectName(QString::fromUtf8("ssTEFixedLabel"));
        ssTEFixedLabel->setFont(font2);

        gridLayout_56->addWidget(ssTEFixedLabel, 0, 0, 1, 1);

        ssTEFixedSpin = new QSpinBox(groupBox);
        ssTEFixedSpin->setObjectName(QString::fromUtf8("ssTEFixedSpin"));
        ssTEFixedSpin->setEnabled(true);
        ssTEFixedSpin->setAlignment(Qt::AlignCenter);
        ssTEFixedSpin->setReadOnly(true);
        ssTEFixedSpin->setButtonSymbols(QAbstractSpinBox::NoButtons);

        gridLayout_56->addWidget(ssTEFixedSpin, 0, 1, 1, 1);

        ssTEFixedEventLabel = new QLabel(groupBox);
        ssTEFixedEventLabel->setObjectName(QString::fromUtf8("ssTEFixedEventLabel"));
        ssTEFixedEventLabel->setFont(font2);
        ssTEFixedEventLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_56->addWidget(ssTEFixedEventLabel, 1, 0, 1, 1);

        ssTEFixedEventSpin = new QSpinBox(groupBox);
        ssTEFixedEventSpin->setObjectName(QString::fromUtf8("ssTEFixedEventSpin"));
        ssTEFixedEventSpin->setEnabled(true);
        ssTEFixedEventSpin->setAlignment(Qt::AlignCenter);
        ssTEFixedEventSpin->setReadOnly(true);
        ssTEFixedEventSpin->setButtonSymbols(QAbstractSpinBox::NoButtons);

        gridLayout_56->addWidget(ssTEFixedEventSpin, 1, 1, 1, 1);


        gridLayout_57->addLayout(gridLayout_56, 0, 0, 1, 1);


        gridLayout_73->addWidget(groupBox, 4, 2, 1, 1);

        ssTEGroup = new QGroupBox(ssTETab);
        ssTEGroup->setObjectName(QString::fromUtf8("ssTEGroup"));
        sizePolicy1.setHeightForWidth(ssTEGroup->sizePolicy().hasHeightForWidth());
        ssTEGroup->setSizePolicy(sizePolicy1);
        gridLayout_55 = new QGridLayout(ssTEGroup);
        gridLayout_55->setSpacing(6);
        gridLayout_55->setContentsMargins(3, 3, 3, 3);
        gridLayout_55->setObjectName(QString::fromUtf8("gridLayout_55"));
        gridLayout_47 = new QGridLayout();
        gridLayout_47->setSpacing(6);
        gridLayout_47->setObjectName(QString::fromUtf8("gridLayout_47"));
        ssTESwitchCombo = new QComboBox(ssTEGroup);
        ssTESwitchCombo->setObjectName(QString::fromUtf8("ssTESwitchCombo"));

        gridLayout_47->addWidget(ssTESwitchCombo, 0, 1, 1, 1);

        ssTECtrlLabel = new QLabel(ssTEGroup);
        ssTECtrlLabel->setObjectName(QString::fromUtf8("ssTECtrlLabel"));

        gridLayout_47->addWidget(ssTECtrlLabel, 1, 0, 1, 1);

        ssTECtrlDSpin = new QwtCounter(ssTEGroup);
        ssTECtrlDSpin->setObjectName(QString::fromUtf8("ssTECtrlDSpin"));
        ssTECtrlDSpin->setProperty("numButtons", QVariant(1));
        ssTECtrlDSpin->setProperty("basicstep", QVariant(1));
        ssTECtrlDSpin->setProperty("maxValue", QVariant(1e+06));
        ssTECtrlDSpin->setProperty("value", QVariant(6));
        ssTECtrlDSpin->setProperty("decimals", QVariant(2));
        ssTECtrlDSpin->setProperty("minimum", QVariant(0.0001));

        gridLayout_47->addWidget(ssTECtrlDSpin, 1, 1, 1, 1);

        ssTEExpLabel = new QLabel(ssTEGroup);
        ssTEExpLabel->setObjectName(QString::fromUtf8("ssTEExpLabel"));

        gridLayout_47->addWidget(ssTEExpLabel, 2, 0, 1, 1);

        ssTEExpDSpin = new QwtCounter(ssTEGroup);
        ssTEExpDSpin->setObjectName(QString::fromUtf8("ssTEExpDSpin"));
        ssTEExpDSpin->setProperty("numButtons", QVariant(1));
        ssTEExpDSpin->setProperty("basicstep", QVariant(1));
        ssTEExpDSpin->setProperty("maxValue", QVariant(1e+06));
        ssTEExpDSpin->setProperty("value", QVariant(10));
        ssTEExpDSpin->setProperty("decimals", QVariant(2));
        ssTEExpDSpin->setProperty("minimum", QVariant(0.0001));

        gridLayout_47->addWidget(ssTEExpDSpin, 2, 1, 1, 1);

        label = new QLabel(ssTEGroup);
        label->setObjectName(QString::fromUtf8("label"));

        gridLayout_47->addWidget(label, 0, 0, 1, 1);

        ssTEDropoutLabel = new QLabel(ssTEGroup);
        ssTEDropoutLabel->setObjectName(QString::fromUtf8("ssTEDropoutLabel"));

        gridLayout_47->addWidget(ssTEDropoutLabel, 3, 0, 1, 1);

        ssTEDropoutDSpin = new QwtCounter(ssTEGroup);
        ssTEDropoutDSpin->setObjectName(QString::fromUtf8("ssTEDropoutDSpin"));
        ssTEDropoutDSpin->setProperty("numButtons", QVariant(1));
        ssTEDropoutDSpin->setProperty("basicstep", QVariant(1));
        ssTEDropoutDSpin->setProperty("maxValue", QVariant(1e+06));
        ssTEDropoutDSpin->setProperty("value", QVariant(12));
        ssTEDropoutDSpin->setProperty("decimals", QVariant(2));

        gridLayout_47->addWidget(ssTEDropoutDSpin, 3, 1, 1, 1);

        ssTEHazardRatioDSpin = new QwtCounter(ssTEGroup);
        ssTEHazardRatioDSpin->setObjectName(QString::fromUtf8("ssTEHazardRatioDSpin"));
        ssTEHazardRatioDSpin->setProperty("numButtons", QVariant(0));
        ssTEHazardRatioDSpin->setProperty("value", QVariant(1));
        ssTEHazardRatioDSpin->setProperty("editable", QVariant(false));
        ssTEHazardRatioDSpin->setProperty("readOnly", QVariant(true));
        ssTEHazardRatioDSpin->setProperty("decimals", QVariant(4));

        gridLayout_47->addWidget(ssTEHazardRatioDSpin, 5, 1, 1, 1);

        ssTEHazardRatioLabel = new QLabel(ssTEGroup);
        ssTEHazardRatioLabel->setObjectName(QString::fromUtf8("ssTEHazardRatioLabel"));
        ssTEHazardRatioLabel->setFont(font2);

        gridLayout_47->addWidget(ssTEHazardRatioLabel, 5, 0, 1, 1);

        line = new QFrame(ssTEGroup);
        line->setObjectName(QString::fromUtf8("line"));
        line->setFrameShape(QFrame::HLine);
        line->setFrameShadow(QFrame::Sunken);

        gridLayout_47->addWidget(line, 4, 0, 1, 1);

        line_2 = new QFrame(ssTEGroup);
        line_2->setObjectName(QString::fromUtf8("line_2"));
        line_2->setFrameShape(QFrame::HLine);
        line_2->setFrameShadow(QFrame::Sunken);

        gridLayout_47->addWidget(line_2, 4, 1, 1, 1);


        gridLayout_55->addLayout(gridLayout_47, 0, 0, 1, 1);


        gridLayout_73->addWidget(ssTEGroup, 0, 0, 2, 1);

        sampleSizeTab->addTab(ssTETab, QString());

        gridLayout_75->addWidget(sampleSizeTab, 0, 0, 1, 1);

        designTab->addTab(ss, QString());
        sf = new QWidget();
        sf->setObjectName(QString::fromUtf8("sf"));
        gridLayout_68 = new QGridLayout(sf);
        gridLayout_68->setSpacing(6);
        gridLayout_68->setContentsMargins(11, 11, 11, 11);
        gridLayout_68->setObjectName(QString::fromUtf8("gridLayout_68"));
        spendingFunctionTab = new QTabWidget(sf);
        spendingFunctionTab->setObjectName(QString::fromUtf8("spendingFunctionTab"));
        sflTab = new QWidget();
        sflTab->setObjectName(QString::fromUtf8("sflTab"));
        gridLayout_64 = new QGridLayout(sflTab);
        gridLayout_64->setSpacing(6);
        gridLayout_64->setContentsMargins(11, 11, 11, 11);
        gridLayout_64->setObjectName(QString::fromUtf8("gridLayout_64"));
        sflParamToolBox = new QToolBox(sflTab);
        sflParamToolBox->setObjectName(QString::fromUtf8("sflParamToolBox"));
        sflParamToolBox->setLayoutDirection(Qt::LeftToRight);
        sflParamToolBox->setFrameShape(QFrame::NoFrame);
        sflParamToolBox->setFrameShadow(QFrame::Plain);
        sflParamToolBox->setLineWidth(1);
        LParameterFree = new QWidget();
        LParameterFree->setObjectName(QString::fromUtf8("LParameterFree"));
        LParameterFree->setGeometry(QRect(0, 0, 161, 71));
        gridLayout_90 = new QGridLayout(LParameterFree);
        gridLayout_90->setSpacing(6);
        gridLayout_90->setContentsMargins(11, 11, 11, 11);
        gridLayout_90->setObjectName(QString::fromUtf8("gridLayout_90"));
        verticalSpacer_35 = new QSpacerItem(20, 69, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_90->addItem(verticalSpacer_35, 0, 1, 1, 1);

        horizontalSpacer_26 = new QSpacerItem(44, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_90->addItem(horizontalSpacer_26, 1, 0, 1, 1);

        sfl0PLLayout = new QGridLayout();
        sfl0PLLayout->setSpacing(6);
        sfl0PLLayout->setObjectName(QString::fromUtf8("sfl0PLLayout"));
        sfl0PCombo = new QComboBox(LParameterFree);
        sfl0PCombo->setObjectName(QString::fromUtf8("sfl0PCombo"));

        sfl0PLLayout->addWidget(sfl0PCombo, 1, 0, 1, 1);

        sfl0PLabel = new QLabel(LParameterFree);
        sfl0PLabel->setObjectName(QString::fromUtf8("sfl0PLabel"));

        sfl0PLLayout->addWidget(sfl0PLabel, 0, 0, 1, 1);


        gridLayout_90->addLayout(sfl0PLLayout, 1, 1, 1, 1);

        horizontalSpacer_27 = new QSpacerItem(44, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_90->addItem(horizontalSpacer_27, 1, 2, 1, 1);

        verticalSpacer_34 = new QSpacerItem(20, 69, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_90->addItem(verticalSpacer_34, 2, 1, 1, 1);

        sflParamToolBox->addItem(LParameterFree, QString::fromUtf8("Parameter Free"));
        LOneParameter = new QWidget();
        LOneParameter->setObjectName(QString::fromUtf8("LOneParameter"));
        LOneParameter->setGeometry(QRect(0, 0, 153, 58));
        gridLayout_89 = new QGridLayout(LOneParameter);
        gridLayout_89->setSpacing(6);
        gridLayout_89->setContentsMargins(11, 11, 11, 11);
        gridLayout_89->setObjectName(QString::fromUtf8("gridLayout_89"));
        verticalSpacer_32 = new QSpacerItem(20, 65, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_89->addItem(verticalSpacer_32, 0, 1, 1, 1);

        horizontalSpacer_24 = new QSpacerItem(43, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_89->addItem(horizontalSpacer_24, 1, 0, 1, 1);

        gridLayout_88 = new QGridLayout();
        gridLayout_88->setSpacing(6);
        gridLayout_88->setObjectName(QString::fromUtf8("gridLayout_88"));
        sfl1PCombo = new QComboBox(LOneParameter);
        sfl1PCombo->setObjectName(QString::fromUtf8("sfl1PCombo"));

        gridLayout_88->addWidget(sfl1PCombo, 0, 0, 1, 1);

        sfl1PDSpin = new QwtCounter(LOneParameter);
        sfl1PDSpin->setObjectName(QString::fromUtf8("sfl1PDSpin"));
        sfl1PDSpin->setEnabled(true);
        sfl1PDSpin->setProperty("numButtons", QVariant(1));
        sfl1PDSpin->setProperty("value", QVariant(0));
        sfl1PDSpin->setProperty("minimum", QVariant(-40));
        sfl1PDSpin->setProperty("maximum", QVariant(40));

        gridLayout_88->addWidget(sfl1PDSpin, 1, 0, 1, 1);


        gridLayout_89->addLayout(gridLayout_88, 1, 1, 1, 1);

        horizontalSpacer_25 = new QSpacerItem(42, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_89->addItem(horizontalSpacer_25, 1, 2, 1, 1);

        verticalSpacer_33 = new QSpacerItem(20, 65, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_89->addItem(verticalSpacer_33, 2, 1, 1, 1);

        sflParamToolBox->addItem(LOneParameter, QString::fromUtf8("1-Parameter"));
        LTwoParameter = new QWidget();
        LTwoParameter->setObjectName(QString::fromUtf8("LTwoParameter"));
        LTwoParameter->setGeometry(QRect(0, 0, 210, 162));
        gridLayout_87 = new QGridLayout(LTwoParameter);
        gridLayout_87->setSpacing(6);
        gridLayout_87->setContentsMargins(11, 11, 11, 11);
        gridLayout_87->setObjectName(QString::fromUtf8("gridLayout_87"));
        verticalSpacer_31 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_87->addItem(verticalSpacer_31, 0, 0, 1, 1);

        sfl2PTab = new QTabWidget(LTwoParameter);
        sfl2PTab->setObjectName(QString::fromUtf8("sfl2PTab"));
        sfl2PFunTab = new QWidget();
        sfl2PFunTab->setObjectName(QString::fromUtf8("sfl2PFunTab"));
        gridLayout_60 = new QGridLayout(sfl2PFunTab);
        gridLayout_60->setSpacing(6);
        gridLayout_60->setContentsMargins(11, 11, 11, 11);
        gridLayout_60->setObjectName(QString::fromUtf8("gridLayout_60"));
        verticalLayout_7 = new QVBoxLayout();
        verticalLayout_7->setSpacing(6);
        verticalLayout_7->setObjectName(QString::fromUtf8("verticalLayout_7"));
        sfl2PFunLayout = new QGridLayout();
        sfl2PFunLayout->setSpacing(6);
        sfl2PFunLayout->setObjectName(QString::fromUtf8("sfl2PFunLayout"));
        sfl2PFunLabel = new QLabel(sfl2PFunTab);
        sfl2PFunLabel->setObjectName(QString::fromUtf8("sfl2PFunLabel"));

        sfl2PFunLayout->addWidget(sfl2PFunLabel, 0, 0, 1, 1);

        sfl2PFunCombo = new QComboBox(sfl2PFunTab);
        sfl2PFunCombo->setObjectName(QString::fromUtf8("sfl2PFunCombo"));

        sfl2PFunLayout->addWidget(sfl2PFunCombo, 0, 1, 1, 1);


        verticalLayout_7->addLayout(sfl2PFunLayout);

        gridLayout_11 = new QGridLayout();
        gridLayout_11->setSpacing(6);
        gridLayout_11->setObjectName(QString::fromUtf8("gridLayout_11"));
        sfl2PPt1Group = new QGroupBox(sfl2PFunTab);
        sfl2PPt1Group->setObjectName(QString::fromUtf8("sfl2PPt1Group"));
        gridLayout_12 = new QGridLayout(sfl2PPt1Group);
        gridLayout_12->setSpacing(6);
        gridLayout_12->setContentsMargins(3, 3, 3, 3);
        gridLayout_12->setObjectName(QString::fromUtf8("gridLayout_12"));
        gridLayout_10 = new QGridLayout();
        gridLayout_10->setSpacing(6);
        gridLayout_10->setObjectName(QString::fromUtf8("gridLayout_10"));
        sfl2PPt1XLabel = new QLabel(sfl2PPt1Group);
        sfl2PPt1XLabel->setObjectName(QString::fromUtf8("sfl2PPt1XLabel"));
        sfl2PPt1XLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_10->addWidget(sfl2PPt1XLabel, 0, 0, 1, 1);

        sfl2PPt1XDSpin = new QwtCounter(sfl2PPt1Group);
        sfl2PPt1XDSpin->setObjectName(QString::fromUtf8("sfl2PPt1XDSpin"));
        sizePolicy5.setHeightForWidth(sfl2PPt1XDSpin->sizePolicy().hasHeightForWidth());
        sfl2PPt1XDSpin->setSizePolicy(sizePolicy5);

        gridLayout_10->addWidget(sfl2PPt1XDSpin, 0, 1, 1, 1);

        sfl2PPt1YLabel = new QLabel(sfl2PPt1Group);
        sfl2PPt1YLabel->setObjectName(QString::fromUtf8("sfl2PPt1YLabel"));
        sfl2PPt1YLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_10->addWidget(sfl2PPt1YLabel, 1, 0, 1, 1);

        sfl2PPt1YDSpin = new QwtCounter(sfl2PPt1Group);
        sfl2PPt1YDSpin->setObjectName(QString::fromUtf8("sfl2PPt1YDSpin"));
        sizePolicy5.setHeightForWidth(sfl2PPt1YDSpin->sizePolicy().hasHeightForWidth());
        sfl2PPt1YDSpin->setSizePolicy(sizePolicy5);

        gridLayout_10->addWidget(sfl2PPt1YDSpin, 1, 1, 1, 1);


        gridLayout_12->addLayout(gridLayout_10, 0, 0, 1, 1);


        gridLayout_11->addWidget(sfl2PPt1Group, 0, 0, 1, 1);

        sfl2PPt2Group = new QGroupBox(sfl2PFunTab);
        sfl2PPt2Group->setObjectName(QString::fromUtf8("sfl2PPt2Group"));
        gridLayout_59 = new QGridLayout(sfl2PPt2Group);
        gridLayout_59->setSpacing(6);
        gridLayout_59->setContentsMargins(3, 3, 3, 3);
        gridLayout_59->setObjectName(QString::fromUtf8("gridLayout_59"));
        gridLayout_9 = new QGridLayout();
        gridLayout_9->setSpacing(6);
        gridLayout_9->setObjectName(QString::fromUtf8("gridLayout_9"));
        sfl2PPt2XLabel = new QLabel(sfl2PPt2Group);
        sfl2PPt2XLabel->setObjectName(QString::fromUtf8("sfl2PPt2XLabel"));
        sfl2PPt2XLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_9->addWidget(sfl2PPt2XLabel, 0, 0, 1, 1);

        sfl2PPt2XDSpin = new QwtCounter(sfl2PPt2Group);
        sfl2PPt2XDSpin->setObjectName(QString::fromUtf8("sfl2PPt2XDSpin"));
        sizePolicy5.setHeightForWidth(sfl2PPt2XDSpin->sizePolicy().hasHeightForWidth());
        sfl2PPt2XDSpin->setSizePolicy(sizePolicy5);

        gridLayout_9->addWidget(sfl2PPt2XDSpin, 0, 1, 1, 1);

        sfl2PPt2YLabel = new QLabel(sfl2PPt2Group);
        sfl2PPt2YLabel->setObjectName(QString::fromUtf8("sfl2PPt2YLabel"));
        sfl2PPt2YLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_9->addWidget(sfl2PPt2YLabel, 1, 0, 1, 1);

        sfl2PPt2YDSpin = new QwtCounter(sfl2PPt2Group);
        sfl2PPt2YDSpin->setObjectName(QString::fromUtf8("sfl2PPt2YDSpin"));
        sizePolicy5.setHeightForWidth(sfl2PPt2YDSpin->sizePolicy().hasHeightForWidth());
        sfl2PPt2YDSpin->setSizePolicy(sizePolicy5);

        gridLayout_9->addWidget(sfl2PPt2YDSpin, 1, 1, 1, 1);


        gridLayout_59->addLayout(gridLayout_9, 0, 0, 1, 1);


        gridLayout_11->addWidget(sfl2PPt2Group, 0, 1, 1, 1);


        verticalLayout_7->addLayout(gridLayout_11);


        gridLayout_60->addLayout(verticalLayout_7, 0, 0, 1, 1);

        sfl2PTab->addTab(sfl2PFunTab, QString());
        sfl2PLMTab = new QWidget();
        sfl2PLMTab->setObjectName(QString::fromUtf8("sfl2PLMTab"));
        gridLayout_100 = new QGridLayout(sfl2PLMTab);
        gridLayout_100->setSpacing(6);
        gridLayout_100->setContentsMargins(11, 11, 11, 11);
        gridLayout_100->setObjectName(QString::fromUtf8("gridLayout_100"));
        gridLayout_3 = new QGridLayout();
        gridLayout_3->setSpacing(6);
        gridLayout_3->setObjectName(QString::fromUtf8("gridLayout_3"));
        sfl2PLMSlpLabel = new QLabel(sfl2PLMTab);
        sfl2PLMSlpLabel->setObjectName(QString::fromUtf8("sfl2PLMSlpLabel"));
        sfl2PLMSlpLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_3->addWidget(sfl2PLMSlpLabel, 0, 0, 1, 1);

        sfl2PLMSlpDSpin = new QwtCounter(sfl2PLMTab);
        sfl2PLMSlpDSpin->setObjectName(QString::fromUtf8("sfl2PLMSlpDSpin"));
        sizePolicy1.setHeightForWidth(sfl2PLMSlpDSpin->sizePolicy().hasHeightForWidth());
        sfl2PLMSlpDSpin->setSizePolicy(sizePolicy1);
        sfl2PLMSlpDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_3->addWidget(sfl2PLMSlpDSpin, 0, 1, 1, 1);

        sfl2PLMIntLabel = new QLabel(sfl2PLMTab);
        sfl2PLMIntLabel->setObjectName(QString::fromUtf8("sfl2PLMIntLabel"));
        sfl2PLMIntLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_3->addWidget(sfl2PLMIntLabel, 1, 0, 1, 1);

        sfl2PLMIntDSpin = new QwtCounter(sfl2PLMTab);
        sfl2PLMIntDSpin->setObjectName(QString::fromUtf8("sfl2PLMIntDSpin"));
        sizePolicy1.setHeightForWidth(sfl2PLMIntDSpin->sizePolicy().hasHeightForWidth());
        sfl2PLMIntDSpin->setSizePolicy(sizePolicy1);
        sfl2PLMIntDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_3->addWidget(sfl2PLMIntDSpin, 1, 1, 1, 1);


        gridLayout_100->addLayout(gridLayout_3, 0, 0, 1, 1);

        sfl2PTab->addTab(sfl2PLMTab, QString());

        gridLayout_87->addWidget(sfl2PTab, 1, 0, 1, 1);

        horizontalSpacer_23 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_87->addItem(horizontalSpacer_23, 1, 1, 1, 1);

        verticalSpacer_30 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_87->addItem(verticalSpacer_30, 2, 0, 1, 1);

        sflParamToolBox->addItem(LTwoParameter, QString::fromUtf8("2-Parameter"));
        LThreeParameter = new QWidget();
        LThreeParameter->setObjectName(QString::fromUtf8("LThreeParameter"));
        LThreeParameter->setGeometry(QRect(0, 0, 166, 151));
        gridLayout_86 = new QGridLayout(LThreeParameter);
        gridLayout_86->setSpacing(6);
        gridLayout_86->setContentsMargins(11, 11, 11, 11);
        gridLayout_86->setObjectName(QString::fromUtf8("gridLayout_86"));
        verticalSpacer_29 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_86->addItem(verticalSpacer_29, 0, 1, 1, 1);

        horizontalSpacer_20 = new QSpacerItem(30, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_86->addItem(horizontalSpacer_20, 1, 0, 1, 1);

        sfl3PTab = new QTabWidget(LThreeParameter);
        sfl3PTab->setObjectName(QString::fromUtf8("sfl3PTab"));
        sfl3PPtsTab = new QWidget();
        sfl3PPtsTab->setObjectName(QString::fromUtf8("sfl3PPtsTab"));
        gridLayout_36 = new QGridLayout(sfl3PPtsTab);
        gridLayout_36->setSpacing(6);
        gridLayout_36->setContentsMargins(11, 11, 11, 11);
        gridLayout_36->setObjectName(QString::fromUtf8("gridLayout_36"));
        gridLayout_35 = new QGridLayout();
        gridLayout_35->setSpacing(6);
        gridLayout_35->setObjectName(QString::fromUtf8("gridLayout_35"));
        sfl3PPt1Group = new QGroupBox(sfl3PPtsTab);
        sfl3PPt1Group->setObjectName(QString::fromUtf8("sfl3PPt1Group"));
        gridLayout_7 = new QGridLayout(sfl3PPt1Group);
        gridLayout_7->setSpacing(6);
        gridLayout_7->setContentsMargins(3, 3, 3, 3);
        gridLayout_7->setObjectName(QString::fromUtf8("gridLayout_7"));
        gridLayout_5 = new QGridLayout();
        gridLayout_5->setSpacing(6);
        gridLayout_5->setObjectName(QString::fromUtf8("gridLayout_5"));
        sfl3PPt1XLabel = new QLabel(sfl3PPt1Group);
        sfl3PPt1XLabel->setObjectName(QString::fromUtf8("sfl3PPt1XLabel"));
        sfl3PPt1XLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_5->addWidget(sfl3PPt1XLabel, 0, 0, 1, 1);

        sfl3PPt1XDSpin = new QwtCounter(sfl3PPt1Group);
        sfl3PPt1XDSpin->setObjectName(QString::fromUtf8("sfl3PPt1XDSpin"));
        sizePolicy5.setHeightForWidth(sfl3PPt1XDSpin->sizePolicy().hasHeightForWidth());
        sfl3PPt1XDSpin->setSizePolicy(sizePolicy5);

        gridLayout_5->addWidget(sfl3PPt1XDSpin, 0, 1, 1, 1);

        sfl3PPt1YLabel = new QLabel(sfl3PPt1Group);
        sfl3PPt1YLabel->setObjectName(QString::fromUtf8("sfl3PPt1YLabel"));
        sfl3PPt1YLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_5->addWidget(sfl3PPt1YLabel, 1, 0, 1, 1);

        sfl3PPt1YDSpin = new QwtCounter(sfl3PPt1Group);
        sfl3PPt1YDSpin->setObjectName(QString::fromUtf8("sfl3PPt1YDSpin"));
        sizePolicy5.setHeightForWidth(sfl3PPt1YDSpin->sizePolicy().hasHeightForWidth());
        sfl3PPt1YDSpin->setSizePolicy(sizePolicy5);

        gridLayout_5->addWidget(sfl3PPt1YDSpin, 1, 1, 1, 1);


        gridLayout_7->addLayout(gridLayout_5, 0, 0, 1, 1);


        gridLayout_35->addWidget(sfl3PPt1Group, 0, 0, 1, 1);

        sfl3PPt2Group = new QGroupBox(sfl3PPtsTab);
        sfl3PPt2Group->setObjectName(QString::fromUtf8("sfl3PPt2Group"));
        gridLayout_34 = new QGridLayout(sfl3PPt2Group);
        gridLayout_34->setSpacing(6);
        gridLayout_34->setContentsMargins(3, 3, 3, 3);
        gridLayout_34->setObjectName(QString::fromUtf8("gridLayout_34"));
        gridLayout_4 = new QGridLayout();
        gridLayout_4->setSpacing(6);
        gridLayout_4->setObjectName(QString::fromUtf8("gridLayout_4"));
        sfl3PPt2XLabel = new QLabel(sfl3PPt2Group);
        sfl3PPt2XLabel->setObjectName(QString::fromUtf8("sfl3PPt2XLabel"));
        sfl3PPt2XLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_4->addWidget(sfl3PPt2XLabel, 0, 0, 1, 1);

        sfl3PPt2XDSpin = new QwtCounter(sfl3PPt2Group);
        sfl3PPt2XDSpin->setObjectName(QString::fromUtf8("sfl3PPt2XDSpin"));
        sizePolicy5.setHeightForWidth(sfl3PPt2XDSpin->sizePolicy().hasHeightForWidth());
        sfl3PPt2XDSpin->setSizePolicy(sizePolicy5);

        gridLayout_4->addWidget(sfl3PPt2XDSpin, 0, 1, 1, 1);

        sfl3PPt2YLabel = new QLabel(sfl3PPt2Group);
        sfl3PPt2YLabel->setObjectName(QString::fromUtf8("sfl3PPt2YLabel"));
        sfl3PPt2YLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_4->addWidget(sfl3PPt2YLabel, 1, 0, 1, 1);

        sfl3PPt2YDSpin = new QwtCounter(sfl3PPt2Group);
        sfl3PPt2YDSpin->setObjectName(QString::fromUtf8("sfl3PPt2YDSpin"));
        QSizePolicy sizePolicy6(QSizePolicy::Minimum, QSizePolicy::Fixed);
        sizePolicy6.setHorizontalStretch(0);
        sizePolicy6.setVerticalStretch(0);
        sizePolicy6.setHeightForWidth(sfl3PPt2YDSpin->sizePolicy().hasHeightForWidth());
        sfl3PPt2YDSpin->setSizePolicy(sizePolicy6);

        gridLayout_4->addWidget(sfl3PPt2YDSpin, 1, 1, 1, 1);


        gridLayout_34->addLayout(gridLayout_4, 0, 0, 1, 1);


        gridLayout_35->addWidget(sfl3PPt2Group, 0, 1, 1, 1);

        sfl3PPtsDfLabel = new QLabel(sfl3PPtsTab);
        sfl3PPtsDfLabel->setObjectName(QString::fromUtf8("sfl3PPtsDfLabel"));
        sfl3PPtsDfLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_35->addWidget(sfl3PPtsDfLabel, 1, 0, 1, 1);

        sfl3PPtsDfDSpin = new QwtCounter(sfl3PPtsTab);
        sfl3PPtsDfDSpin->setObjectName(QString::fromUtf8("sfl3PPtsDfDSpin"));

        gridLayout_35->addWidget(sfl3PPtsDfDSpin, 1, 1, 1, 1);


        gridLayout_36->addLayout(gridLayout_35, 0, 0, 1, 1);

        sfl3PTab->addTab(sfl3PPtsTab, QString());
        sfl3PLMTab = new QWidget();
        sfl3PLMTab->setObjectName(QString::fromUtf8("sfl3PLMTab"));
        gridLayout_52 = new QGridLayout(sfl3PLMTab);
        gridLayout_52->setSpacing(6);
        gridLayout_52->setContentsMargins(11, 11, 11, 11);
        gridLayout_52->setObjectName(QString::fromUtf8("gridLayout_52"));
        gridLayout_25 = new QGridLayout();
        gridLayout_25->setSpacing(6);
        gridLayout_25->setObjectName(QString::fromUtf8("gridLayout_25"));
        sfl3PLMSlpLayer = new QLabel(sfl3PLMTab);
        sfl3PLMSlpLayer->setObjectName(QString::fromUtf8("sfl3PLMSlpLayer"));
        sfl3PLMSlpLayer->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_25->addWidget(sfl3PLMSlpLayer, 0, 0, 1, 1);

        sfl3PLMSlpDSpin = new QwtCounter(sfl3PLMTab);
        sfl3PLMSlpDSpin->setObjectName(QString::fromUtf8("sfl3PLMSlpDSpin"));
        sfl3PLMSlpDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_25->addWidget(sfl3PLMSlpDSpin, 0, 1, 1, 1);

        sfl3PLMIntLabel = new QLabel(sfl3PLMTab);
        sfl3PLMIntLabel->setObjectName(QString::fromUtf8("sfl3PLMIntLabel"));
        sfl3PLMIntLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_25->addWidget(sfl3PLMIntLabel, 1, 0, 1, 1);

        sfl3PLMIntDSpin = new QwtCounter(sfl3PLMTab);
        sfl3PLMIntDSpin->setObjectName(QString::fromUtf8("sfl3PLMIntDSpin"));
        sfl3PLMIntDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_25->addWidget(sfl3PLMIntDSpin, 1, 1, 1, 1);

        sfl3PLMDfLabel = new QLabel(sfl3PLMTab);
        sfl3PLMDfLabel->setObjectName(QString::fromUtf8("sfl3PLMDfLabel"));
        sfl3PLMDfLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_25->addWidget(sfl3PLMDfLabel, 2, 0, 1, 1);

        sfl3PLMDfDSpin = new QwtCounter(sfl3PLMTab);
        sfl3PLMDfDSpin->setObjectName(QString::fromUtf8("sfl3PLMDfDSpin"));
        sfl3PLMDfDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_25->addWidget(sfl3PLMDfDSpin, 2, 1, 1, 1);


        gridLayout_52->addLayout(gridLayout_25, 0, 0, 1, 1);

        sfl3PTab->addTab(sfl3PLMTab, QString());

        gridLayout_86->addWidget(sfl3PTab, 1, 1, 1, 1);

        horizontalSpacer_21 = new QSpacerItem(31, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_86->addItem(horizontalSpacer_21, 1, 2, 1, 1);

        verticalSpacer_28 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_86->addItem(verticalSpacer_28, 2, 1, 1, 1);

        sflParamToolBox->addItem(LThreeParameter, QString::fromUtf8("3-Parameter"));
        LPiecewiseLinear = new QWidget();
        LPiecewiseLinear->setObjectName(QString::fromUtf8("LPiecewiseLinear"));
        LPiecewiseLinear->setGeometry(QRect(0, 0, 340, 135));
        gridLayout_85 = new QGridLayout(LPiecewiseLinear);
        gridLayout_85->setSpacing(6);
        gridLayout_85->setContentsMargins(11, 11, 11, 11);
        gridLayout_85->setObjectName(QString::fromUtf8("gridLayout_85"));
        verticalSpacer_27 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_85->addItem(verticalSpacer_27, 0, 2, 1, 1);

        horizontalSpacer_18 = new QSpacerItem(38, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_85->addItem(horizontalSpacer_18, 1, 0, 1, 1);

        gridLayout_48 = new QGridLayout();
        gridLayout_48->setSpacing(6);
        gridLayout_48->setObjectName(QString::fromUtf8("gridLayout_48"));
        gridLayout_48->setSizeConstraint(QLayout::SetMaximumSize);
        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setSpacing(6);
        horizontalLayout_4->setObjectName(QString::fromUtf8("horizontalLayout_4"));
        gridLayout_13 = new QGridLayout();
        gridLayout_13->setSpacing(6);
        gridLayout_13->setObjectName(QString::fromUtf8("gridLayout_13"));
        sflPiecePtsLabel = new QLabel(LPiecewiseLinear);
        sflPiecePtsLabel->setObjectName(QString::fromUtf8("sflPiecePtsLabel"));

        gridLayout_13->addWidget(sflPiecePtsLabel, 0, 0, 1, 1);

        sflPiecePtsSpin = new QSpinBox(LPiecewiseLinear);
        sflPiecePtsSpin->setObjectName(QString::fromUtf8("sflPiecePtsSpin"));
        sflPiecePtsSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        sflPiecePtsSpin->setMinimum(1);
        sflPiecePtsSpin->setValue(3);

        gridLayout_13->addWidget(sflPiecePtsSpin, 0, 1, 1, 1);


        horizontalLayout_4->addLayout(gridLayout_13);

        sflPieceUseInterimRadio = new QRadioButton(LPiecewiseLinear);
        sflPieceUseInterimRadio->setObjectName(QString::fromUtf8("sflPieceUseInterimRadio"));
        sflPieceUseInterimRadio->setLayoutDirection(Qt::LeftToRight);

        horizontalLayout_4->addWidget(sflPieceUseInterimRadio);


        gridLayout_48->addLayout(horizontalLayout_4, 0, 0, 1, 1);

        sflPieceHorizontalLayout = new QHBoxLayout();
        sflPieceHorizontalLayout->setSpacing(6);
        sflPieceHorizontalLayout->setObjectName(QString::fromUtf8("sflPieceHorizontalLayout"));
        sflPieceTableX = new QTableWidget(LPiecewiseLinear);
        if (sflPieceTableX->columnCount() < 1)
            sflPieceTableX->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem4 = new QTableWidgetItem();
        sflPieceTableX->setHorizontalHeaderItem(0, __qtablewidgetitem4);
        if (sflPieceTableX->rowCount() < 3)
            sflPieceTableX->setRowCount(3);
        QTableWidgetItem *__qtablewidgetitem5 = new QTableWidgetItem();
        __qtablewidgetitem5->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sflPieceTableX->setItem(0, 0, __qtablewidgetitem5);
        QTableWidgetItem *__qtablewidgetitem6 = new QTableWidgetItem();
        __qtablewidgetitem6->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sflPieceTableX->setItem(1, 0, __qtablewidgetitem6);
        QTableWidgetItem *__qtablewidgetitem7 = new QTableWidgetItem();
        __qtablewidgetitem7->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sflPieceTableX->setItem(2, 0, __qtablewidgetitem7);
        sflPieceTableX->setObjectName(QString::fromUtf8("sflPieceTableX"));
        QSizePolicy sizePolicy7(QSizePolicy::Fixed, QSizePolicy::Expanding);
        sizePolicy7.setHorizontalStretch(0);
        sizePolicy7.setVerticalStretch(0);
        sizePolicy7.setHeightForWidth(sflPieceTableX->sizePolicy().hasHeightForWidth());
        sflPieceTableX->setSizePolicy(sizePolicy7);
        sflPieceTableX->setMinimumSize(QSize(0, 0));
        sflPieceTableX->setMaximumSize(QSize(150, 16777215));
        sflPieceTableX->setBaseSize(QSize(0, 0));
        sflPieceTableX->setFont(font1);
        sflPieceTableX->setFocusPolicy(Qt::WheelFocus);
        sflPieceTableX->setAutoFillBackground(true);
        sflPieceTableX->setProperty("showDropIndicator", QVariant(true));
        sflPieceTableX->setSortingEnabled(false);
        sflPieceTableX->setRowCount(3);
        sflPieceTableX->setColumnCount(1);
        sflPieceTableX->horizontalHeader()->setCascadingSectionResizes(true);
        sflPieceTableX->horizontalHeader()->setDefaultSectionSize(167);
        sflPieceTableX->horizontalHeader()->setStretchLastSection(true);
        sflPieceTableX->verticalHeader()->setCascadingSectionResizes(true);
        sflPieceTableX->verticalHeader()->setStretchLastSection(false);

        sflPieceHorizontalLayout->addWidget(sflPieceTableX);

        sflPieceTableY = new QTableWidget(LPiecewiseLinear);
        if (sflPieceTableY->columnCount() < 1)
            sflPieceTableY->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem8 = new QTableWidgetItem();
        sflPieceTableY->setHorizontalHeaderItem(0, __qtablewidgetitem8);
        if (sflPieceTableY->rowCount() < 3)
            sflPieceTableY->setRowCount(3);
        QTableWidgetItem *__qtablewidgetitem9 = new QTableWidgetItem();
        __qtablewidgetitem9->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sflPieceTableY->setItem(0, 0, __qtablewidgetitem9);
        QTableWidgetItem *__qtablewidgetitem10 = new QTableWidgetItem();
        __qtablewidgetitem10->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sflPieceTableY->setItem(1, 0, __qtablewidgetitem10);
        QTableWidgetItem *__qtablewidgetitem11 = new QTableWidgetItem();
        __qtablewidgetitem11->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sflPieceTableY->setItem(2, 0, __qtablewidgetitem11);
        sflPieceTableY->setObjectName(QString::fromUtf8("sflPieceTableY"));
        sizePolicy7.setHeightForWidth(sflPieceTableY->sizePolicy().hasHeightForWidth());
        sflPieceTableY->setSizePolicy(sizePolicy7);
        sflPieceTableY->setMinimumSize(QSize(0, 0));
        sflPieceTableY->setMaximumSize(QSize(150, 16777215));
        sflPieceTableY->setBaseSize(QSize(0, 0));
        sflPieceTableY->setFont(font1);
        sflPieceTableY->setAutoFillBackground(true);
        sflPieceTableY->setProperty("showDropIndicator", QVariant(true));
        sflPieceTableY->setSortingEnabled(false);
        sflPieceTableY->setRowCount(3);
        sflPieceTableY->setColumnCount(1);
        sflPieceTableY->horizontalHeader()->setCascadingSectionResizes(true);
        sflPieceTableY->horizontalHeader()->setDefaultSectionSize(167);
        sflPieceTableY->horizontalHeader()->setProperty("showSortIndicator", QVariant(false));
        sflPieceTableY->horizontalHeader()->setStretchLastSection(true);
        sflPieceTableY->verticalHeader()->setCascadingSectionResizes(true);
        sflPieceTableY->verticalHeader()->setProperty("showSortIndicator", QVariant(false));
        sflPieceTableY->verticalHeader()->setStretchLastSection(false);

        sflPieceHorizontalLayout->addWidget(sflPieceTableY);


        gridLayout_48->addLayout(sflPieceHorizontalLayout, 1, 0, 1, 1);


        gridLayout_85->addLayout(gridLayout_48, 1, 1, 1, 2);

        horizontalSpacer_19 = new QSpacerItem(38, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_85->addItem(horizontalSpacer_19, 1, 3, 1, 1);

        verticalSpacer_26 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_85->addItem(verticalSpacer_26, 2, 1, 1, 1);

        sflParamToolBox->addItem(LPiecewiseLinear, QString::fromUtf8("Piecewise Linear"));

        gridLayout_64->addWidget(sflParamToolBox, 0, 0, 1, 1);

        spendingFunctionTab->addTab(sflTab, QString());
        sfuTab = new QWidget();
        sfuTab->setObjectName(QString::fromUtf8("sfuTab"));
        gridLayout_63 = new QGridLayout(sfuTab);
        gridLayout_63->setSpacing(6);
        gridLayout_63->setContentsMargins(11, 11, 11, 11);
        gridLayout_63->setObjectName(QString::fromUtf8("gridLayout_63"));
        sfuParamToolBox = new QToolBox(sfuTab);
        sfuParamToolBox->setObjectName(QString::fromUtf8("sfuParamToolBox"));
        QSizePolicy sizePolicy8(QSizePolicy::Preferred, QSizePolicy::Preferred);
        sizePolicy8.setHorizontalStretch(0);
        sizePolicy8.setVerticalStretch(0);
        sizePolicy8.setHeightForWidth(sfuParamToolBox->sizePolicy().hasHeightForWidth());
        sfuParamToolBox->setSizePolicy(sizePolicy8);
        sfuParamToolBox->setLayoutDirection(Qt::LeftToRight);
        sfuParamToolBox->setFrameShape(QFrame::NoFrame);
        sfuParamToolBox->setFrameShadow(QFrame::Plain);
        sfuParamToolBox->setLineWidth(1);
        UParameterFree = new QWidget();
        UParameterFree->setObjectName(QString::fromUtf8("UParameterFree"));
        UParameterFree->setGeometry(QRect(0, 0, 161, 71));
        gridLayout_91 = new QGridLayout(UParameterFree);
        gridLayout_91->setSpacing(6);
        gridLayout_91->setContentsMargins(11, 11, 11, 11);
        gridLayout_91->setObjectName(QString::fromUtf8("gridLayout_91"));
        verticalSpacer_36 = new QSpacerItem(20, 69, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_91->addItem(verticalSpacer_36, 0, 1, 1, 1);

        horizontalSpacer_28 = new QSpacerItem(221, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_91->addItem(horizontalSpacer_28, 1, 0, 1, 1);

        sfl0PLLayout_2 = new QGridLayout();
        sfl0PLLayout_2->setSpacing(6);
        sfl0PLLayout_2->setObjectName(QString::fromUtf8("sfl0PLLayout_2"));
        sfu0PCombo = new QComboBox(UParameterFree);
        sfu0PCombo->setObjectName(QString::fromUtf8("sfu0PCombo"));

        sfl0PLLayout_2->addWidget(sfu0PCombo, 1, 0, 1, 1);

        sfu0PLabel = new QLabel(UParameterFree);
        sfu0PLabel->setObjectName(QString::fromUtf8("sfu0PLabel"));

        sfl0PLLayout_2->addWidget(sfu0PLabel, 0, 0, 1, 1);


        gridLayout_91->addLayout(sfl0PLLayout_2, 1, 1, 1, 1);

        horizontalSpacer_29 = new QSpacerItem(221, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_91->addItem(horizontalSpacer_29, 1, 2, 1, 1);

        verticalSpacer_37 = new QSpacerItem(20, 69, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_91->addItem(verticalSpacer_37, 2, 1, 1, 1);

        sfuParamToolBox->addItem(UParameterFree, QString::fromUtf8("Parameter Free"));
        UOneParameter = new QWidget();
        UOneParameter->setObjectName(QString::fromUtf8("UOneParameter"));
        UOneParameter->setGeometry(QRect(0, 0, 153, 58));
        gridLayout_93 = new QGridLayout(UOneParameter);
        gridLayout_93->setSpacing(6);
        gridLayout_93->setContentsMargins(11, 11, 11, 11);
        gridLayout_93->setObjectName(QString::fromUtf8("gridLayout_93"));
        verticalSpacer_39 = new QSpacerItem(20, 65, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_93->addItem(verticalSpacer_39, 0, 1, 1, 1);

        horizontalSpacer_30 = new QSpacerItem(159, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_93->addItem(horizontalSpacer_30, 1, 0, 1, 1);

        gridLayout_92 = new QGridLayout();
        gridLayout_92->setSpacing(6);
        gridLayout_92->setObjectName(QString::fromUtf8("gridLayout_92"));
        sfu1PCombo = new QComboBox(UOneParameter);
        sfu1PCombo->setObjectName(QString::fromUtf8("sfu1PCombo"));

        gridLayout_92->addWidget(sfu1PCombo, 0, 0, 1, 1);

        sfu1PDSpin = new QwtCounter(UOneParameter);
        sfu1PDSpin->setObjectName(QString::fromUtf8("sfu1PDSpin"));
        sfu1PDSpin->setEnabled(true);
        sfu1PDSpin->setProperty("numButtons", QVariant(1));
        sfu1PDSpin->setProperty("value", QVariant(0));
        sfu1PDSpin->setProperty("minimum", QVariant(-40));
        sfu1PDSpin->setProperty("maximum", QVariant(40));

        gridLayout_92->addWidget(sfu1PDSpin, 1, 0, 1, 1);


        gridLayout_93->addLayout(gridLayout_92, 1, 1, 1, 1);

        horizontalSpacer_31 = new QSpacerItem(159, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_93->addItem(horizontalSpacer_31, 1, 2, 1, 1);

        verticalSpacer_38 = new QSpacerItem(20, 65, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_93->addItem(verticalSpacer_38, 2, 1, 1, 1);

        sfuParamToolBox->addItem(UOneParameter, QString::fromUtf8("1-Parameter"));
        UTwoParameter = new QWidget();
        UTwoParameter->setObjectName(QString::fromUtf8("UTwoParameter"));
        UTwoParameter->setGeometry(QRect(0, 0, 216, 162));
        gridLayout_95 = new QGridLayout(UTwoParameter);
        gridLayout_95->setSpacing(6);
        gridLayout_95->setContentsMargins(11, 11, 11, 11);
        gridLayout_95->setObjectName(QString::fromUtf8("gridLayout_95"));
        verticalSpacer_41 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_95->addItem(verticalSpacer_41, 0, 1, 1, 1);

        horizontalSpacer_32 = new QSpacerItem(102, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_95->addItem(horizontalSpacer_32, 1, 0, 1, 1);

        sfu2PTab = new QTabWidget(UTwoParameter);
        sfu2PTab->setObjectName(QString::fromUtf8("sfu2PTab"));
        sfu2P = new QWidget();
        sfu2P->setObjectName(QString::fromUtf8("sfu2P"));
        gridLayout_58 = new QGridLayout(sfu2P);
        gridLayout_58->setSpacing(6);
        gridLayout_58->setContentsMargins(11, 11, 11, 11);
        gridLayout_58->setObjectName(QString::fromUtf8("gridLayout_58"));
        verticalLayout_5 = new QVBoxLayout();
        verticalLayout_5->setSpacing(6);
        verticalLayout_5->setObjectName(QString::fromUtf8("verticalLayout_5"));
        sfu2PFunLayout = new QGridLayout();
        sfu2PFunLayout->setSpacing(6);
        sfu2PFunLayout->setObjectName(QString::fromUtf8("sfu2PFunLayout"));
        sfu2PFunLabel = new QLabel(sfu2P);
        sfu2PFunLabel->setObjectName(QString::fromUtf8("sfu2PFunLabel"));

        sfu2PFunLayout->addWidget(sfu2PFunLabel, 0, 0, 1, 1);

        sfu2PFunCombo = new QComboBox(sfu2P);
        sfu2PFunCombo->setObjectName(QString::fromUtf8("sfu2PFunCombo"));

        sfu2PFunLayout->addWidget(sfu2PFunCombo, 0, 1, 1, 1);


        verticalLayout_5->addLayout(sfu2PFunLayout);

        gridLayout_15 = new QGridLayout();
        gridLayout_15->setSpacing(6);
        gridLayout_15->setObjectName(QString::fromUtf8("gridLayout_15"));
        sfu2PPt1Group = new QGroupBox(sfu2P);
        sfu2PPt1Group->setObjectName(QString::fromUtf8("sfu2PPt1Group"));
        QSizePolicy sizePolicy9(QSizePolicy::MinimumExpanding, QSizePolicy::Preferred);
        sizePolicy9.setHorizontalStretch(0);
        sizePolicy9.setVerticalStretch(0);
        sizePolicy9.setHeightForWidth(sfu2PPt1Group->sizePolicy().hasHeightForWidth());
        sfu2PPt1Group->setSizePolicy(sizePolicy9);
        gridLayout_29 = new QGridLayout(sfu2PPt1Group);
        gridLayout_29->setSpacing(6);
        gridLayout_29->setContentsMargins(3, 3, 3, 3);
        gridLayout_29->setObjectName(QString::fromUtf8("gridLayout_29"));
        gridLayout_17 = new QGridLayout();
        gridLayout_17->setSpacing(6);
        gridLayout_17->setObjectName(QString::fromUtf8("gridLayout_17"));
        sfu2PPt1XLabel = new QLabel(sfu2PPt1Group);
        sfu2PPt1XLabel->setObjectName(QString::fromUtf8("sfu2PPt1XLabel"));

        gridLayout_17->addWidget(sfu2PPt1XLabel, 0, 0, 1, 1);

        sfu2PPt1XDSpin = new QwtCounter(sfu2PPt1Group);
        sfu2PPt1XDSpin->setObjectName(QString::fromUtf8("sfu2PPt1XDSpin"));
        sizePolicy5.setHeightForWidth(sfu2PPt1XDSpin->sizePolicy().hasHeightForWidth());
        sfu2PPt1XDSpin->setSizePolicy(sizePolicy5);

        gridLayout_17->addWidget(sfu2PPt1XDSpin, 0, 1, 1, 1);

        sfu2PPt1YLabel = new QLabel(sfu2PPt1Group);
        sfu2PPt1YLabel->setObjectName(QString::fromUtf8("sfu2PPt1YLabel"));

        gridLayout_17->addWidget(sfu2PPt1YLabel, 1, 0, 1, 1);

        sfu2PPt1YDSpin = new QwtCounter(sfu2PPt1Group);
        sfu2PPt1YDSpin->setObjectName(QString::fromUtf8("sfu2PPt1YDSpin"));
        sizePolicy5.setHeightForWidth(sfu2PPt1YDSpin->sizePolicy().hasHeightForWidth());
        sfu2PPt1YDSpin->setSizePolicy(sizePolicy5);

        gridLayout_17->addWidget(sfu2PPt1YDSpin, 1, 1, 1, 1);


        gridLayout_29->addLayout(gridLayout_17, 0, 0, 1, 1);


        gridLayout_15->addWidget(sfu2PPt1Group, 0, 0, 1, 1);

        sfu2PPt2Group = new QGroupBox(sfu2P);
        sfu2PPt2Group->setObjectName(QString::fromUtf8("sfu2PPt2Group"));
        sizePolicy9.setHeightForWidth(sfu2PPt2Group->sizePolicy().hasHeightForWidth());
        sfu2PPt2Group->setSizePolicy(sizePolicy9);
        gridLayout_16 = new QGridLayout(sfu2PPt2Group);
        gridLayout_16->setSpacing(6);
        gridLayout_16->setContentsMargins(3, 3, 3, 3);
        gridLayout_16->setObjectName(QString::fromUtf8("gridLayout_16"));
        gridLayout_14 = new QGridLayout();
        gridLayout_14->setSpacing(6);
        gridLayout_14->setObjectName(QString::fromUtf8("gridLayout_14"));
        sfu2PPt2XLabel = new QLabel(sfu2PPt2Group);
        sfu2PPt2XLabel->setObjectName(QString::fromUtf8("sfu2PPt2XLabel"));

        gridLayout_14->addWidget(sfu2PPt2XLabel, 0, 0, 1, 1);

        sfu2PPt2XDSpin = new QwtCounter(sfu2PPt2Group);
        sfu2PPt2XDSpin->setObjectName(QString::fromUtf8("sfu2PPt2XDSpin"));
        sizePolicy5.setHeightForWidth(sfu2PPt2XDSpin->sizePolicy().hasHeightForWidth());
        sfu2PPt2XDSpin->setSizePolicy(sizePolicy5);

        gridLayout_14->addWidget(sfu2PPt2XDSpin, 0, 1, 1, 1);

        sfu2PPt2YLabel = new QLabel(sfu2PPt2Group);
        sfu2PPt2YLabel->setObjectName(QString::fromUtf8("sfu2PPt2YLabel"));

        gridLayout_14->addWidget(sfu2PPt2YLabel, 1, 0, 1, 1);

        sfu2PPt2YDSpin = new QwtCounter(sfu2PPt2Group);
        sfu2PPt2YDSpin->setObjectName(QString::fromUtf8("sfu2PPt2YDSpin"));
        sizePolicy5.setHeightForWidth(sfu2PPt2YDSpin->sizePolicy().hasHeightForWidth());
        sfu2PPt2YDSpin->setSizePolicy(sizePolicy5);

        gridLayout_14->addWidget(sfu2PPt2YDSpin, 1, 1, 1, 1);


        gridLayout_16->addLayout(gridLayout_14, 0, 0, 1, 1);


        gridLayout_15->addWidget(sfu2PPt2Group, 0, 1, 1, 1);


        verticalLayout_5->addLayout(gridLayout_15);


        gridLayout_58->addLayout(verticalLayout_5, 0, 0, 1, 1);

        sfu2PTab->addTab(sfu2P, QString());
        sfl2PLMTab_2 = new QWidget();
        sfl2PLMTab_2->setObjectName(QString::fromUtf8("sfl2PLMTab_2"));
        gridLayout_94 = new QGridLayout(sfl2PLMTab_2);
        gridLayout_94->setSpacing(6);
        gridLayout_94->setContentsMargins(11, 11, 11, 11);
        gridLayout_94->setObjectName(QString::fromUtf8("gridLayout_94"));
        gridLayout_18 = new QGridLayout();
        gridLayout_18->setSpacing(6);
        gridLayout_18->setObjectName(QString::fromUtf8("gridLayout_18"));
        sfu2PLMSlpLabel = new QLabel(sfl2PLMTab_2);
        sfu2PLMSlpLabel->setObjectName(QString::fromUtf8("sfu2PLMSlpLabel"));
        sfu2PLMSlpLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_18->addWidget(sfu2PLMSlpLabel, 0, 0, 1, 1);

        sfu2PLMSlpDSpin = new QwtCounter(sfl2PLMTab_2);
        sfu2PLMSlpDSpin->setObjectName(QString::fromUtf8("sfu2PLMSlpDSpin"));
        sizePolicy1.setHeightForWidth(sfu2PLMSlpDSpin->sizePolicy().hasHeightForWidth());
        sfu2PLMSlpDSpin->setSizePolicy(sizePolicy1);
        sfu2PLMSlpDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_18->addWidget(sfu2PLMSlpDSpin, 0, 1, 1, 1);

        sfu2PLMIntLabel = new QLabel(sfl2PLMTab_2);
        sfu2PLMIntLabel->setObjectName(QString::fromUtf8("sfu2PLMIntLabel"));
        sfu2PLMIntLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_18->addWidget(sfu2PLMIntLabel, 1, 0, 1, 1);

        sfu2PLMIntDSpin = new QwtCounter(sfl2PLMTab_2);
        sfu2PLMIntDSpin->setObjectName(QString::fromUtf8("sfu2PLMIntDSpin"));
        sizePolicy1.setHeightForWidth(sfu2PLMIntDSpin->sizePolicy().hasHeightForWidth());
        sfu2PLMIntDSpin->setSizePolicy(sizePolicy1);
        sfu2PLMIntDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_18->addWidget(sfu2PLMIntDSpin, 1, 1, 1, 1);


        gridLayout_94->addLayout(gridLayout_18, 0, 0, 1, 1);

        sfu2PTab->addTab(sfl2PLMTab_2, QString());

        gridLayout_95->addWidget(sfu2PTab, 1, 1, 1, 1);

        horizontalSpacer_33 = new QSpacerItem(102, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_95->addItem(horizontalSpacer_33, 1, 2, 1, 1);

        verticalSpacer_40 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_95->addItem(verticalSpacer_40, 2, 1, 1, 1);

        sfuParamToolBox->addItem(UTwoParameter, QString::fromUtf8("2-Parameter"));
        UThreeParameter = new QWidget();
        UThreeParameter->setObjectName(QString::fromUtf8("UThreeParameter"));
        UThreeParameter->setGeometry(QRect(0, 0, 166, 151));
        gridLayout_96 = new QGridLayout(UThreeParameter);
        gridLayout_96->setSpacing(6);
        gridLayout_96->setContentsMargins(11, 11, 11, 11);
        gridLayout_96->setObjectName(QString::fromUtf8("gridLayout_96"));
        verticalSpacer_43 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_96->addItem(verticalSpacer_43, 0, 1, 1, 1);

        horizontalSpacer_34 = new QSpacerItem(96, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_96->addItem(horizontalSpacer_34, 1, 0, 1, 1);

        sfu3PTab = new QTabWidget(UThreeParameter);
        sfu3PTab->setObjectName(QString::fromUtf8("sfu3PTab"));
        sfu3PPts = new QWidget();
        sfu3PPts->setObjectName(QString::fromUtf8("sfu3PPts"));
        gridLayout_20 = new QGridLayout(sfu3PPts);
        gridLayout_20->setSpacing(6);
        gridLayout_20->setContentsMargins(11, 11, 11, 11);
        gridLayout_20->setObjectName(QString::fromUtf8("gridLayout_20"));
        gridLayout_19 = new QGridLayout();
        gridLayout_19->setSpacing(6);
        gridLayout_19->setObjectName(QString::fromUtf8("gridLayout_19"));
        sfu3PPt1Group = new QGroupBox(sfu3PPts);
        sfu3PPt1Group->setObjectName(QString::fromUtf8("sfu3PPt1Group"));
        gridLayout_50 = new QGridLayout(sfu3PPt1Group);
        gridLayout_50->setSpacing(6);
        gridLayout_50->setContentsMargins(3, 3, 3, 3);
        gridLayout_50->setObjectName(QString::fromUtf8("gridLayout_50"));
        gridLayout_21 = new QGridLayout();
        gridLayout_21->setSpacing(6);
        gridLayout_21->setObjectName(QString::fromUtf8("gridLayout_21"));
        sfu3PPt1XLabel = new QLabel(sfu3PPt1Group);
        sfu3PPt1XLabel->setObjectName(QString::fromUtf8("sfu3PPt1XLabel"));
        sfu3PPt1XLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_21->addWidget(sfu3PPt1XLabel, 0, 0, 1, 1);

        sfu3PPt1XDSpin = new QwtCounter(sfu3PPt1Group);
        sfu3PPt1XDSpin->setObjectName(QString::fromUtf8("sfu3PPt1XDSpin"));
        sizePolicy5.setHeightForWidth(sfu3PPt1XDSpin->sizePolicy().hasHeightForWidth());
        sfu3PPt1XDSpin->setSizePolicy(sizePolicy5);
        sfu3PPt1XDSpin->setProperty("decimals", QVariant(4));

        gridLayout_21->addWidget(sfu3PPt1XDSpin, 0, 1, 1, 1);

        sfu3PPt1YLabel = new QLabel(sfu3PPt1Group);
        sfu3PPt1YLabel->setObjectName(QString::fromUtf8("sfu3PPt1YLabel"));
        sfu3PPt1YLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_21->addWidget(sfu3PPt1YLabel, 1, 0, 1, 1);

        sfu3PPt1YDSpin = new QwtCounter(sfu3PPt1Group);
        sfu3PPt1YDSpin->setObjectName(QString::fromUtf8("sfu3PPt1YDSpin"));
        sizePolicy1.setHeightForWidth(sfu3PPt1YDSpin->sizePolicy().hasHeightForWidth());
        sfu3PPt1YDSpin->setSizePolicy(sizePolicy1);
        sfu3PPt1YDSpin->setProperty("decimals", QVariant(4));

        gridLayout_21->addWidget(sfu3PPt1YDSpin, 1, 1, 1, 1);


        gridLayout_50->addLayout(gridLayout_21, 0, 0, 1, 1);


        gridLayout_19->addWidget(sfu3PPt1Group, 0, 0, 1, 1);

        sfu3PPt2Group = new QGroupBox(sfu3PPts);
        sfu3PPt2Group->setObjectName(QString::fromUtf8("sfu3PPt2Group"));
        gridLayout_49 = new QGridLayout(sfu3PPt2Group);
        gridLayout_49->setSpacing(6);
        gridLayout_49->setContentsMargins(3, 3, 3, 3);
        gridLayout_49->setObjectName(QString::fromUtf8("gridLayout_49"));
        gridLayout_22 = new QGridLayout();
        gridLayout_22->setSpacing(6);
        gridLayout_22->setObjectName(QString::fromUtf8("gridLayout_22"));
        sfu3PPt2XLabel = new QLabel(sfu3PPt2Group);
        sfu3PPt2XLabel->setObjectName(QString::fromUtf8("sfu3PPt2XLabel"));
        sizePolicy1.setHeightForWidth(sfu3PPt2XLabel->sizePolicy().hasHeightForWidth());
        sfu3PPt2XLabel->setSizePolicy(sizePolicy1);
        sfu3PPt2XLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_22->addWidget(sfu3PPt2XLabel, 0, 0, 1, 1);

        sfu3PPt2XDSpin = new QwtCounter(sfu3PPt2Group);
        sfu3PPt2XDSpin->setObjectName(QString::fromUtf8("sfu3PPt2XDSpin"));
        sizePolicy5.setHeightForWidth(sfu3PPt2XDSpin->sizePolicy().hasHeightForWidth());
        sfu3PPt2XDSpin->setSizePolicy(sizePolicy5);
        sfu3PPt2XDSpin->setProperty("decimals", QVariant(4));

        gridLayout_22->addWidget(sfu3PPt2XDSpin, 0, 1, 1, 1);

        sfu3PPt2YLabel = new QLabel(sfu3PPt2Group);
        sfu3PPt2YLabel->setObjectName(QString::fromUtf8("sfu3PPt2YLabel"));
        sfu3PPt2YLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_22->addWidget(sfu3PPt2YLabel, 1, 0, 1, 1);

        sfu3PPt2YDSpin = new QwtCounter(sfu3PPt2Group);
        sfu3PPt2YDSpin->setObjectName(QString::fromUtf8("sfu3PPt2YDSpin"));
        sfu3PPt2YDSpin->setProperty("decimals", QVariant(4));

        gridLayout_22->addWidget(sfu3PPt2YDSpin, 1, 1, 1, 1);


        gridLayout_49->addLayout(gridLayout_22, 0, 0, 1, 1);


        gridLayout_19->addWidget(sfu3PPt2Group, 0, 1, 1, 1);

        sfu3PPtsDfLabel = new QLabel(sfu3PPts);
        sfu3PPtsDfLabel->setObjectName(QString::fromUtf8("sfu3PPtsDfLabel"));
        sfu3PPtsDfLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_19->addWidget(sfu3PPtsDfLabel, 1, 0, 1, 1);

        sfu3PPtsDfDSpin = new QwtCounter(sfu3PPts);
        sfu3PPtsDfDSpin->setObjectName(QString::fromUtf8("sfu3PPtsDfDSpin"));
        sfu3PPtsDfDSpin->setProperty("decimals", QVariant(4));

        gridLayout_19->addWidget(sfu3PPtsDfDSpin, 1, 1, 1, 1);


        gridLayout_20->addLayout(gridLayout_19, 0, 0, 1, 1);

        sfu3PTab->addTab(sfu3PPts, QString());
        sfu3PLMTab = new QWidget();
        sfu3PLMTab->setObjectName(QString::fromUtf8("sfu3PLMTab"));
        gridLayout_51 = new QGridLayout(sfu3PLMTab);
        gridLayout_51->setSpacing(6);
        gridLayout_51->setContentsMargins(11, 11, 11, 11);
        gridLayout_51->setObjectName(QString::fromUtf8("gridLayout_51"));
        gridLayout_28 = new QGridLayout();
        gridLayout_28->setSpacing(6);
        gridLayout_28->setObjectName(QString::fromUtf8("gridLayout_28"));
        gridLayout_28->setSizeConstraint(QLayout::SetDefaultConstraint);
        sfu3PLMSlpLabel = new QLabel(sfu3PLMTab);
        sfu3PLMSlpLabel->setObjectName(QString::fromUtf8("sfu3PLMSlpLabel"));
        sfu3PLMSlpLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_28->addWidget(sfu3PLMSlpLabel, 0, 0, 1, 1);

        sfu3PLMSlpDSpin = new QwtCounter(sfu3PLMTab);
        sfu3PLMSlpDSpin->setObjectName(QString::fromUtf8("sfu3PLMSlpDSpin"));
        sfu3PLMSlpDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_28->addWidget(sfu3PLMSlpDSpin, 0, 1, 1, 1);

        sfu3PLMIntLabel = new QLabel(sfu3PLMTab);
        sfu3PLMIntLabel->setObjectName(QString::fromUtf8("sfu3PLMIntLabel"));
        sfu3PLMIntLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_28->addWidget(sfu3PLMIntLabel, 1, 0, 1, 1);

        sfu3PLMIntDSpin = new QwtCounter(sfu3PLMTab);
        sfu3PLMIntDSpin->setObjectName(QString::fromUtf8("sfu3PLMIntDSpin"));
        sfu3PLMIntDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_28->addWidget(sfu3PLMIntDSpin, 1, 1, 1, 1);

        sfu3PLMDfLabel = new QLabel(sfu3PLMTab);
        sfu3PLMDfLabel->setObjectName(QString::fromUtf8("sfu3PLMDfLabel"));
        sfu3PLMDfLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_28->addWidget(sfu3PLMDfLabel, 2, 0, 1, 1);

        sfu3PLMDfDSpin = new QwtCounter(sfu3PLMTab);
        sfu3PLMDfDSpin->setObjectName(QString::fromUtf8("sfu3PLMDfDSpin"));
        sfu3PLMDfDSpin->setProperty("numButtons", QVariant(1));

        gridLayout_28->addWidget(sfu3PLMDfDSpin, 2, 1, 1, 1);


        gridLayout_51->addLayout(gridLayout_28, 0, 0, 1, 1);

        sfu3PTab->addTab(sfu3PLMTab, QString());

        gridLayout_96->addWidget(sfu3PTab, 1, 1, 1, 1);

        horizontalSpacer_35 = new QSpacerItem(95, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_96->addItem(horizontalSpacer_35, 1, 2, 1, 1);

        verticalSpacer_42 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_96->addItem(verticalSpacer_42, 2, 1, 1, 1);

        sfuParamToolBox->addItem(UThreeParameter, QString::fromUtf8("3-Parameter"));
        UPiecewiseLinear = new QWidget();
        UPiecewiseLinear->setObjectName(QString::fromUtf8("UPiecewiseLinear"));
        UPiecewiseLinear->setGeometry(QRect(0, 0, 239, 135));
        gridLayout_97 = new QGridLayout(UPiecewiseLinear);
        gridLayout_97->setSpacing(6);
        gridLayout_97->setContentsMargins(11, 11, 11, 11);
        gridLayout_97->setObjectName(QString::fromUtf8("gridLayout_97"));
        verticalSpacer_45 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_97->addItem(verticalSpacer_45, 0, 1, 1, 1);

        horizontalSpacer_36 = new QSpacerItem(122, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_97->addItem(horizontalSpacer_36, 1, 0, 1, 1);

        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        verticalLayout_3->setSizeConstraint(QLayout::SetMaximumSize);
        gridLayout_31 = new QGridLayout();
        gridLayout_31->setSpacing(6);
        gridLayout_31->setObjectName(QString::fromUtf8("gridLayout_31"));
        gridLayout_23 = new QGridLayout();
        gridLayout_23->setSpacing(6);
        gridLayout_23->setObjectName(QString::fromUtf8("gridLayout_23"));
        sfuPiecePtsLabel = new QLabel(UPiecewiseLinear);
        sfuPiecePtsLabel->setObjectName(QString::fromUtf8("sfuPiecePtsLabel"));

        gridLayout_23->addWidget(sfuPiecePtsLabel, 0, 0, 1, 1);

        sfuPiecePtsSpin = new QSpinBox(UPiecewiseLinear);
        sfuPiecePtsSpin->setObjectName(QString::fromUtf8("sfuPiecePtsSpin"));
        sfuPiecePtsSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        sfuPiecePtsSpin->setMinimum(1);
        sfuPiecePtsSpin->setValue(3);

        gridLayout_23->addWidget(sfuPiecePtsSpin, 0, 1, 1, 1);


        gridLayout_31->addLayout(gridLayout_23, 0, 0, 1, 1);

        sfuPieceUseInterimRadio = new QRadioButton(UPiecewiseLinear);
        sfuPieceUseInterimRadio->setObjectName(QString::fromUtf8("sfuPieceUseInterimRadio"));
        sfuPieceUseInterimRadio->setLayoutDirection(Qt::LeftToRight);

        gridLayout_31->addWidget(sfuPieceUseInterimRadio, 0, 1, 1, 1);


        verticalLayout_3->addLayout(gridLayout_31);

        sfuPieceHorizontalLayout = new QHBoxLayout();
        sfuPieceHorizontalLayout->setSpacing(6);
        sfuPieceHorizontalLayout->setObjectName(QString::fromUtf8("sfuPieceHorizontalLayout"));
        sfuPieceHorizontalLayout->setSizeConstraint(QLayout::SetMaximumSize);
        sfuPieceTableX = new QTableWidget(UPiecewiseLinear);
        if (sfuPieceTableX->columnCount() < 1)
            sfuPieceTableX->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem12 = new QTableWidgetItem();
        sfuPieceTableX->setHorizontalHeaderItem(0, __qtablewidgetitem12);
        if (sfuPieceTableX->rowCount() < 3)
            sfuPieceTableX->setRowCount(3);
        QTableWidgetItem *__qtablewidgetitem13 = new QTableWidgetItem();
        __qtablewidgetitem13->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sfuPieceTableX->setItem(0, 0, __qtablewidgetitem13);
        QTableWidgetItem *__qtablewidgetitem14 = new QTableWidgetItem();
        __qtablewidgetitem14->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sfuPieceTableX->setItem(1, 0, __qtablewidgetitem14);
        QTableWidgetItem *__qtablewidgetitem15 = new QTableWidgetItem();
        __qtablewidgetitem15->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sfuPieceTableX->setItem(2, 0, __qtablewidgetitem15);
        sfuPieceTableX->setObjectName(QString::fromUtf8("sfuPieceTableX"));
        sizePolicy2.setHeightForWidth(sfuPieceTableX->sizePolicy().hasHeightForWidth());
        sfuPieceTableX->setSizePolicy(sizePolicy2);
        sfuPieceTableX->setMinimumSize(QSize(0, 0));
        sfuPieceTableX->setMaximumSize(QSize(150, 16777215));
        sfuPieceTableX->setBaseSize(QSize(0, 0));
        sfuPieceTableX->setFont(font1);
        sfuPieceTableX->setAutoFillBackground(true);
        sfuPieceTableX->setProperty("showDropIndicator", QVariant(true));
        sfuPieceTableX->setSortingEnabled(false);
        sfuPieceTableX->setRowCount(3);
        sfuPieceTableX->setColumnCount(1);
        sfuPieceTableX->horizontalHeader()->setCascadingSectionResizes(true);
        sfuPieceTableX->horizontalHeader()->setDefaultSectionSize(50);
        sfuPieceTableX->horizontalHeader()->setStretchLastSection(true);
        sfuPieceTableX->verticalHeader()->setCascadingSectionResizes(true);
        sfuPieceTableX->verticalHeader()->setStretchLastSection(false);

        sfuPieceHorizontalLayout->addWidget(sfuPieceTableX);

        sfuPieceTableY = new QTableWidget(UPiecewiseLinear);
        if (sfuPieceTableY->columnCount() < 1)
            sfuPieceTableY->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem16 = new QTableWidgetItem();
        sfuPieceTableY->setHorizontalHeaderItem(0, __qtablewidgetitem16);
        if (sfuPieceTableY->rowCount() < 3)
            sfuPieceTableY->setRowCount(3);
        QTableWidgetItem *__qtablewidgetitem17 = new QTableWidgetItem();
        __qtablewidgetitem17->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sfuPieceTableY->setItem(0, 0, __qtablewidgetitem17);
        QTableWidgetItem *__qtablewidgetitem18 = new QTableWidgetItem();
        __qtablewidgetitem18->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sfuPieceTableY->setItem(1, 0, __qtablewidgetitem18);
        QTableWidgetItem *__qtablewidgetitem19 = new QTableWidgetItem();
        __qtablewidgetitem19->setTextAlignment(Qt::AlignRight|Qt::AlignVCenter);
        sfuPieceTableY->setItem(2, 0, __qtablewidgetitem19);
        sfuPieceTableY->setObjectName(QString::fromUtf8("sfuPieceTableY"));
        sizePolicy2.setHeightForWidth(sfuPieceTableY->sizePolicy().hasHeightForWidth());
        sfuPieceTableY->setSizePolicy(sizePolicy2);
        sfuPieceTableY->setMinimumSize(QSize(0, 0));
        sfuPieceTableY->setMaximumSize(QSize(150, 16777215));
        sfuPieceTableY->setBaseSize(QSize(0, 0));
        sfuPieceTableY->setFont(font1);
        sfuPieceTableY->setAutoFillBackground(true);
        sfuPieceTableY->setProperty("showDropIndicator", QVariant(true));
        sfuPieceTableY->setSortingEnabled(false);
        sfuPieceTableY->setRowCount(3);
        sfuPieceTableY->setColumnCount(1);
        sfuPieceTableY->horizontalHeader()->setCascadingSectionResizes(true);
        sfuPieceTableY->horizontalHeader()->setDefaultSectionSize(120);
        sfuPieceTableY->horizontalHeader()->setProperty("showSortIndicator", QVariant(false));
        sfuPieceTableY->horizontalHeader()->setStretchLastSection(true);
        sfuPieceTableY->verticalHeader()->setCascadingSectionResizes(true);
        sfuPieceTableY->verticalHeader()->setProperty("showSortIndicator", QVariant(false));
        sfuPieceTableY->verticalHeader()->setStretchLastSection(false);

        sfuPieceHorizontalLayout->addWidget(sfuPieceTableY);


        verticalLayout_3->addLayout(sfuPieceHorizontalLayout);


        gridLayout_97->addLayout(verticalLayout_3, 1, 1, 1, 1);

        horizontalSpacer_37 = new QSpacerItem(122, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_97->addItem(horizontalSpacer_37, 1, 2, 1, 1);

        verticalSpacer_44 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_97->addItem(verticalSpacer_44, 2, 1, 1, 1);

        sfuParamToolBox->addItem(UPiecewiseLinear, QString::fromUtf8("Piecewise Linear"));

        gridLayout_63->addWidget(sfuParamToolBox, 0, 1, 1, 1);

        verticalLayout_19 = new QVBoxLayout();
        verticalLayout_19->setSpacing(6);
        verticalLayout_19->setObjectName(QString::fromUtf8("verticalLayout_19"));
        tdTestingBox = new QGroupBox(sfuTab);
        tdTestingBox->setObjectName(QString::fromUtf8("tdTestingBox"));
        gridLayout_99 = new QGridLayout(tdTestingBox);
        gridLayout_99->setSpacing(6);
        gridLayout_99->setContentsMargins(11, 11, 11, 11);
        gridLayout_99->setObjectName(QString::fromUtf8("gridLayout_99"));
        gridLayout_104 = new QGridLayout();
        gridLayout_104->setSpacing(6);
        gridLayout_104->setObjectName(QString::fromUtf8("gridLayout_104"));
        verticalLayout_20 = new QVBoxLayout();
        verticalLayout_20->setSpacing(6);
        verticalLayout_20->setObjectName(QString::fromUtf8("verticalLayout_20"));
        sflTestLabel = new QLabel(tdTestingBox);
        sflTestLabel->setObjectName(QString::fromUtf8("sflTestLabel"));

        verticalLayout_20->addWidget(sflTestLabel);

        sflTestCombo = new QComboBox(tdTestingBox);
        sflTestCombo->setObjectName(QString::fromUtf8("sflTestCombo"));
        sflTestCombo->setLayoutDirection(Qt::LeftToRight);

        verticalLayout_20->addWidget(sflTestCombo);


        gridLayout_104->addLayout(verticalLayout_20, 0, 0, 1, 1);

        verticalSpacer_50 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_104->addItem(verticalSpacer_50, 1, 0, 1, 1);

        verticalLayout_21 = new QVBoxLayout();
        verticalLayout_21->setSpacing(6);
        verticalLayout_21->setObjectName(QString::fromUtf8("verticalLayout_21"));
        sflLBSLabel = new QLabel(tdTestingBox);
        sflLBSLabel->setObjectName(QString::fromUtf8("sflLBSLabel"));

        verticalLayout_21->addWidget(sflLBSLabel);

        sflLBSCombo = new QComboBox(tdTestingBox);
        sflLBSCombo->setObjectName(QString::fromUtf8("sflLBSCombo"));

        verticalLayout_21->addWidget(sflLBSCombo);


        gridLayout_104->addLayout(verticalLayout_21, 2, 0, 1, 1);

        verticalSpacer_51 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_104->addItem(verticalSpacer_51, 3, 0, 1, 1);

        verticalLayout_22 = new QVBoxLayout();
        verticalLayout_22->setSpacing(6);
        verticalLayout_22->setObjectName(QString::fromUtf8("verticalLayout_22"));
        sflLBTLabel = new QLabel(tdTestingBox);
        sflLBTLabel->setObjectName(QString::fromUtf8("sflLBTLabel"));

        verticalLayout_22->addWidget(sflLBTLabel);

        sflLBTCombo = new QComboBox(tdTestingBox);
        sflLBTCombo->setObjectName(QString::fromUtf8("sflLBTCombo"));

        verticalLayout_22->addWidget(sflLBTCombo);


        gridLayout_104->addLayout(verticalLayout_22, 4, 0, 1, 1);


        gridLayout_99->addLayout(gridLayout_104, 0, 0, 1, 1);


        verticalLayout_19->addWidget(tdTestingBox);

        verticalSpacer_52 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_19->addItem(verticalSpacer_52);


        gridLayout_63->addLayout(verticalLayout_19, 0, 0, 1, 1);

        spendingFunctionTab->addTab(sfuTab, QString());

        gridLayout_68->addWidget(spendingFunctionTab, 0, 0, 1, 1);

        designTab->addTab(sf, QString());

        gridLayout_65->addWidget(designTab, 0, 0, 1, 1);

        modeStack->addWidget(DesignPage);
        AnalysisPage = new QWidget();
        AnalysisPage->setObjectName(QString::fromUtf8("AnalysisPage"));
        gridLayout_81 = new QGridLayout(AnalysisPage);
        gridLayout_81->setSpacing(6);
        gridLayout_81->setContentsMargins(11, 11, 11, 11);
        gridLayout_81->setObjectName(QString::fromUtf8("gridLayout_81"));
        analysisTab = new QTabWidget(AnalysisPage);
        analysisTab->setObjectName(QString::fromUtf8("analysisTab"));
        epss = new QWidget();
        epss->setObjectName(QString::fromUtf8("epss"));
        gridLayout_84 = new QGridLayout(epss);
        gridLayout_84->setSpacing(6);
        gridLayout_84->setContentsMargins(11, 11, 11, 11);
        gridLayout_84->setObjectName(QString::fromUtf8("gridLayout_84"));
        verticalSpacer_20 = new QSpacerItem(20, 15, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_84->addItem(verticalSpacer_20, 0, 1, 1, 1);

        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setSpacing(6);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        anlErrorPowerSampleGroup = new QGroupBox(epss);
        anlErrorPowerSampleGroup->setObjectName(QString::fromUtf8("anlErrorPowerSampleGroup"));
        gridLayout_79 = new QGridLayout(anlErrorPowerSampleGroup);
        gridLayout_79->setSpacing(6);
        gridLayout_79->setContentsMargins(3, 3, 3, 3);
        gridLayout_79->setObjectName(QString::fromUtf8("gridLayout_79"));
        gridLayout_78 = new QGridLayout();
        gridLayout_78->setSpacing(6);
        gridLayout_78->setObjectName(QString::fromUtf8("gridLayout_78"));
        anlErrorLabel = new QLabel(anlErrorPowerSampleGroup);
        anlErrorLabel->setObjectName(QString::fromUtf8("anlErrorLabel"));
        anlErrorLabel->setFont(font2);

        gridLayout_78->addWidget(anlErrorLabel, 0, 0, 1, 1);

        anlErrorDSpin = new QwtCounter(anlErrorPowerSampleGroup);
        anlErrorDSpin->setObjectName(QString::fromUtf8("anlErrorDSpin"));
        anlErrorDSpin->setMaximumSize(QSize(150, 16777215));
        anlErrorDSpin->setProperty("numButtons", QVariant(1));
        anlErrorDSpin->setProperty("basicstep", QVariant(0.1));
        anlErrorDSpin->setProperty("maxValue", QVariant(100));
        anlErrorDSpin->setProperty("value", QVariant(2.5));
        anlErrorDSpin->setProperty("readOnly", QVariant(true));
        anlErrorDSpin->setProperty("decimals", QVariant(4));
        anlErrorDSpin->setProperty("maximum", QVariant(100));
        anlErrorDSpin->setProperty("singleStep", QVariant(0.1));

        gridLayout_78->addWidget(anlErrorDSpin, 0, 1, 1, 1);

        anlPowerLabel = new QLabel(anlErrorPowerSampleGroup);
        anlPowerLabel->setObjectName(QString::fromUtf8("anlPowerLabel"));
        anlPowerLabel->setFont(font2);

        gridLayout_78->addWidget(anlPowerLabel, 1, 0, 1, 1);

        anlPowerDSpin = new QwtCounter(anlErrorPowerSampleGroup);
        anlPowerDSpin->setObjectName(QString::fromUtf8("anlPowerDSpin"));
        sizePolicy6.setHeightForWidth(anlPowerDSpin->sizePolicy().hasHeightForWidth());
        anlPowerDSpin->setSizePolicy(sizePolicy6);
        anlPowerDSpin->setMaximumSize(QSize(150, 16777215));
        anlPowerDSpin->setLayoutDirection(Qt::LeftToRight);
        anlPowerDSpin->setProperty("numButtons", QVariant(1));
        anlPowerDSpin->setProperty("basicstep", QVariant(0.5));
        anlPowerDSpin->setProperty("maxValue", QVariant(100));
        anlPowerDSpin->setProperty("stepButton1", QVariant(1));
        anlPowerDSpin->setProperty("value", QVariant(90));
        anlPowerDSpin->setProperty("readOnly", QVariant(true));
        anlPowerDSpin->setProperty("decimals", QVariant(1));
        anlPowerDSpin->setProperty("singleStep", QVariant(0.5));

        gridLayout_78->addWidget(anlPowerDSpin, 1, 1, 1, 1);


        gridLayout_79->addLayout(gridLayout_78, 0, 0, 1, 1);


        verticalLayout_2->addWidget(anlErrorPowerSampleGroup);

        verticalSpacer_18 = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_2->addItem(verticalSpacer_18);

        analSampleSizeGroup = new QGroupBox(epss);
        analSampleSizeGroup->setObjectName(QString::fromUtf8("analSampleSizeGroup"));
        gridLayout_77 = new QGridLayout(analSampleSizeGroup);
        gridLayout_77->setSpacing(6);
        gridLayout_77->setContentsMargins(3, 3, 3, 3);
        gridLayout_77->setObjectName(QString::fromUtf8("gridLayout_77"));
        gridLayout_8 = new QGridLayout();
        gridLayout_8->setSpacing(6);
        gridLayout_8->setObjectName(QString::fromUtf8("gridLayout_8"));
        anlMaxSampleSizeLabel = new QLabel(analSampleSizeGroup);
        anlMaxSampleSizeLabel->setObjectName(QString::fromUtf8("anlMaxSampleSizeLabel"));
        anlMaxSampleSizeLabel->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        gridLayout_8->addWidget(anlMaxSampleSizeLabel, 0, 1, 1, 1);

        anlMaxSampleSizeSpin = new QSpinBox(analSampleSizeGroup);
        anlMaxSampleSizeSpin->setObjectName(QString::fromUtf8("anlMaxSampleSizeSpin"));
        QSizePolicy sizePolicy10(QSizePolicy::Expanding, QSizePolicy::Fixed);
        sizePolicy10.setHorizontalStretch(0);
        sizePolicy10.setVerticalStretch(0);
        sizePolicy10.setHeightForWidth(anlMaxSampleSizeSpin->sizePolicy().hasHeightForWidth());
        anlMaxSampleSizeSpin->setSizePolicy(sizePolicy10);
        anlMaxSampleSizeSpin->setMaximumSize(QSize(150, 16777215));
        anlMaxSampleSizeSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        anlMaxSampleSizeSpin->setMinimum(1);
        anlMaxSampleSizeSpin->setValue(3);

        gridLayout_8->addWidget(anlMaxSampleSizeSpin, 0, 2, 1, 1);

        horizontalSpacer_12 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_8->addItem(horizontalSpacer_12, 1, 1, 1, 1);

        anlSampleSizeTable = new QTableWidget(analSampleSizeGroup);
        if (anlSampleSizeTable->columnCount() < 1)
            anlSampleSizeTable->setColumnCount(1);
        QTableWidgetItem *__qtablewidgetitem20 = new QTableWidgetItem();
        anlSampleSizeTable->setHorizontalHeaderItem(0, __qtablewidgetitem20);
        if (anlSampleSizeTable->rowCount() < 3)
            anlSampleSizeTable->setRowCount(3);
        QTableWidgetItem *__qtablewidgetitem21 = new QTableWidgetItem();
        anlSampleSizeTable->setItem(0, 0, __qtablewidgetitem21);
        QTableWidgetItem *__qtablewidgetitem22 = new QTableWidgetItem();
        anlSampleSizeTable->setItem(1, 0, __qtablewidgetitem22);
        QTableWidgetItem *__qtablewidgetitem23 = new QTableWidgetItem();
        anlSampleSizeTable->setItem(2, 0, __qtablewidgetitem23);
        anlSampleSizeTable->setObjectName(QString::fromUtf8("anlSampleSizeTable"));
        anlSampleSizeTable->setMaximumSize(QSize(150, 16777215));
        anlSampleSizeTable->setAlternatingRowColors(false);
        anlSampleSizeTable->setRowCount(3);
        anlSampleSizeTable->horizontalHeader()->setDefaultSectionSize(160);
        anlSampleSizeTable->horizontalHeader()->setStretchLastSection(true);

        gridLayout_8->addWidget(anlSampleSizeTable, 1, 2, 1, 1);


        gridLayout_77->addLayout(gridLayout_8, 1, 0, 1, 1);

        anlLockTimesRadio = new QRadioButton(analSampleSizeGroup);
        anlLockTimesRadio->setObjectName(QString::fromUtf8("anlLockTimesRadio"));

        gridLayout_77->addWidget(anlLockTimesRadio, 2, 0, 1, 1);


        verticalLayout_2->addWidget(analSampleSizeGroup);


        gridLayout_84->addLayout(verticalLayout_2, 1, 1, 4, 1);

        horizontalSpacer_17 = new QSpacerItem(112, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_84->addItem(horizontalSpacer_17, 1, 3, 1, 1);

        horizontalSpacer_7 = new QSpacerItem(37, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_84->addItem(horizontalSpacer_7, 2, 0, 1, 1);

        verticalSpacer_25 = new QSpacerItem(20, 274, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_84->addItem(verticalSpacer_25, 3, 3, 1, 1);

        horizontalSpacer_16 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_84->addItem(horizontalSpacer_16, 4, 2, 1, 1);

        groupBox_4 = new QGroupBox(epss);
        groupBox_4->setObjectName(QString::fromUtf8("groupBox_4"));
        gridLayout_80 = new QGridLayout(groupBox_4);
        gridLayout_80->setSpacing(6);
        gridLayout_80->setContentsMargins(3, 3, 3, 3);
        gridLayout_80->setObjectName(QString::fromUtf8("gridLayout_80"));
        gridLayout_83 = new QGridLayout();
        gridLayout_83->setSpacing(6);
        gridLayout_83->setObjectName(QString::fromUtf8("gridLayout_83"));
        anlMaxnIPlanDSpin = new QwtCounter(groupBox_4);
        anlMaxnIPlanDSpin->setObjectName(QString::fromUtf8("anlMaxnIPlanDSpin"));
        anlMaxnIPlanDSpin->setEnabled(false);
        anlMaxnIPlanDSpin->setProperty("numButtons", QVariant(1));
        anlMaxnIPlanDSpin->setProperty("readOnly", QVariant(true));

        gridLayout_83->addWidget(anlMaxnIPlanDSpin, 0, 0, 1, 1);


        gridLayout_80->addLayout(gridLayout_83, 0, 0, 1, 1);


        gridLayout_84->addWidget(groupBox_4, 4, 3, 1, 1);

        horizontalSpacer_8 = new QSpacerItem(39, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_84->addItem(horizontalSpacer_8, 4, 4, 1, 1);

        verticalSpacer_21 = new QSpacerItem(20, 19, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_84->addItem(verticalSpacer_21, 5, 1, 1, 1);

        verticalSpacer_24 = new QSpacerItem(20, 19, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_84->addItem(verticalSpacer_24, 5, 3, 1, 1);

        analysisTab->addTab(epss, QString());

        gridLayout_81->addWidget(analysisTab, 0, 0, 1, 1);

        modeStack->addWidget(AnalysisPage);
        SimulationPage = new QWidget();
        SimulationPage->setObjectName(QString::fromUtf8("SimulationPage"));
        gridLayout_53 = new QGridLayout(SimulationPage);
        gridLayout_53->setSpacing(6);
        gridLayout_53->setContentsMargins(11, 11, 11, 11);
        gridLayout_53->setObjectName(QString::fromUtf8("gridLayout_53"));
        verticalSpacer_23 = new QSpacerItem(20, 237, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_53->addItem(verticalSpacer_23, 0, 1, 1, 1);

        horizontalSpacer_14 = new QSpacerItem(230, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_53->addItem(horizontalSpacer_14, 1, 0, 1, 1);

        label_3 = new QLabel(SimulationPage);
        label_3->setObjectName(QString::fromUtf8("label_3"));

        gridLayout_53->addWidget(label_3, 1, 1, 1, 1);

        horizontalSpacer_15 = new QSpacerItem(229, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_53->addItem(horizontalSpacer_15, 1, 2, 1, 1);

        verticalSpacer_22 = new QSpacerItem(20, 237, QSizePolicy::Minimum, QSizePolicy::Expanding);

        gridLayout_53->addItem(verticalSpacer_22, 2, 1, 1, 1);

        modeStack->addWidget(SimulationPage);
        opEdit = new QWidget();
        opEdit->setObjectName(QString::fromUtf8("opEdit"));
        verticalLayout_11 = new QVBoxLayout(opEdit);
        verticalLayout_11->setSpacing(6);
        verticalLayout_11->setContentsMargins(11, 11, 11, 11);
        verticalLayout_11->setObjectName(QString::fromUtf8("verticalLayout_11"));
        verticalSpacer_6 = new QSpacerItem(20, 20, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_11->addItem(verticalSpacer_6);

        groupBox_2 = new QGroupBox(opEdit);
        groupBox_2->setObjectName(QString::fromUtf8("groupBox_2"));
        gridLayout_26 = new QGridLayout(groupBox_2);
        gridLayout_26->setSpacing(6);
        gridLayout_26->setContentsMargins(3, 3, 3, 3);
        gridLayout_26->setObjectName(QString::fromUtf8("gridLayout_26"));
        horizontalLayout_7 = new QHBoxLayout();
        horizontalLayout_7->setSpacing(6);
        horizontalLayout_7->setObjectName(QString::fromUtf8("horizontalLayout_7"));
        label_2 = new QLabel(groupBox_2);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        horizontalLayout_7->addWidget(label_2);

        opTypeCombo = new QComboBox(groupBox_2);
        opTypeCombo->setObjectName(QString::fromUtf8("opTypeCombo"));

        horizontalLayout_7->addWidget(opTypeCombo);


        gridLayout_26->addLayout(horizontalLayout_7, 0, 0, 1, 1);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        gridLayout_26->addItem(horizontalSpacer, 0, 1, 1, 1);

        gridLayout_24 = new QGridLayout();
        gridLayout_24->setSpacing(6);
        gridLayout_24->setObjectName(QString::fromUtf8("gridLayout_24"));
        opPlotRenderLabel = new QLabel(groupBox_2);
        opPlotRenderLabel->setObjectName(QString::fromUtf8("opPlotRenderLabel"));

        gridLayout_24->addWidget(opPlotRenderLabel, 0, 0, 1, 1);

        opPlotRenderCombo = new QComboBox(groupBox_2);
        opPlotRenderCombo->setObjectName(QString::fromUtf8("opPlotRenderCombo"));

        gridLayout_24->addWidget(opPlotRenderCombo, 0, 1, 1, 1);


        gridLayout_26->addLayout(gridLayout_24, 0, 2, 1, 1);


        verticalLayout_11->addWidget(groupBox_2);

        verticalSpacer_5 = new QSpacerItem(20, 20, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_11->addItem(verticalSpacer_5);

        opLabelsGroup = new QGroupBox(opEdit);
        opLabelsGroup->setObjectName(QString::fromUtf8("opLabelsGroup"));
        gridLayout_44 = new QGridLayout(opLabelsGroup);
        gridLayout_44->setSpacing(6);
        gridLayout_44->setContentsMargins(6, 6, 6, 6);
        gridLayout_44->setObjectName(QString::fromUtf8("gridLayout_44"));
        gridLayout_38 = new QGridLayout();
        gridLayout_38->setSpacing(6);
        gridLayout_38->setObjectName(QString::fromUtf8("gridLayout_38"));
        opTitleLabel = new QLabel(opLabelsGroup);
        opTitleLabel->setObjectName(QString::fromUtf8("opTitleLabel"));

        gridLayout_38->addWidget(opTitleLabel, 0, 0, 1, 1);

        opTitleLine = new QLineEdit(opLabelsGroup);
        opTitleLine->setObjectName(QString::fromUtf8("opTitleLine"));

        gridLayout_38->addWidget(opTitleLine, 0, 1, 1, 1);

        opXLabelLabel = new QLabel(opLabelsGroup);
        opXLabelLabel->setObjectName(QString::fromUtf8("opXLabelLabel"));

        gridLayout_38->addWidget(opXLabelLabel, 1, 0, 1, 1);

        opXLabelLine = new QLineEdit(opLabelsGroup);
        opXLabelLine->setObjectName(QString::fromUtf8("opXLabelLine"));

        gridLayout_38->addWidget(opXLabelLine, 1, 1, 1, 1);

        opYLabelLeftLabel = new QLabel(opLabelsGroup);
        opYLabelLeftLabel->setObjectName(QString::fromUtf8("opYLabelLeftLabel"));

        gridLayout_38->addWidget(opYLabelLeftLabel, 2, 0, 1, 1);

        opYLabelLeftLine = new QLineEdit(opLabelsGroup);
        opYLabelLeftLine->setObjectName(QString::fromUtf8("opYLabelLeftLine"));

        gridLayout_38->addWidget(opYLabelLeftLine, 2, 1, 1, 1);


        gridLayout_44->addLayout(gridLayout_38, 0, 0, 1, 1);


        verticalLayout_11->addWidget(opLabelsGroup);

        verticalSpacer_2 = new QSpacerItem(20, 20, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_11->addItem(verticalSpacer_2);

        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setSpacing(6);
        horizontalLayout_5->setObjectName(QString::fromUtf8("horizontalLayout_5"));
        opLine1Group = new QGroupBox(opEdit);
        opLine1Group->setObjectName(QString::fromUtf8("opLine1Group"));
        gridLayout_42 = new QGridLayout(opLine1Group);
        gridLayout_42->setSpacing(6);
        gridLayout_42->setContentsMargins(6, 6, 6, 6);
        gridLayout_42->setObjectName(QString::fromUtf8("gridLayout_42"));
        gridLayout_43 = new QGridLayout();
        gridLayout_43->setSpacing(6);
        gridLayout_43->setObjectName(QString::fromUtf8("gridLayout_43"));
        gridLayout_43->setContentsMargins(-1, -1, -1, 4);
        opLine1WidthLabel = new QLabel(opLine1Group);
        opLine1WidthLabel->setObjectName(QString::fromUtf8("opLine1WidthLabel"));
        opLine1WidthLabel->setAlignment(Qt::AlignBottom|Qt::AlignLeading|Qt::AlignLeft);

        gridLayout_43->addWidget(opLine1WidthLabel, 0, 0, 1, 1);

        opLine1WidthSpin = new QSpinBox(opLine1Group);
        opLine1WidthSpin->setObjectName(QString::fromUtf8("opLine1WidthSpin"));
        opLine1WidthSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        opLine1WidthSpin->setValue(2);

        gridLayout_43->addWidget(opLine1WidthSpin, 0, 1, 1, 1);

        opLine1ColorLabel = new QLabel(opLine1Group);
        opLine1ColorLabel->setObjectName(QString::fromUtf8("opLine1ColorLabel"));

        gridLayout_43->addWidget(opLine1ColorLabel, 1, 0, 1, 1);

        opLine1ColorCombo = new QComboBox(opLine1Group);
        opLine1ColorCombo->setObjectName(QString::fromUtf8("opLine1ColorCombo"));

        gridLayout_43->addWidget(opLine1ColorCombo, 1, 1, 1, 1);

        opLine1TypeLabel = new QLabel(opLine1Group);
        opLine1TypeLabel->setObjectName(QString::fromUtf8("opLine1TypeLabel"));

        gridLayout_43->addWidget(opLine1TypeLabel, 2, 0, 1, 1);

        opLine1TypeCombo = new QComboBox(opLine1Group);
        opLine1TypeCombo->setObjectName(QString::fromUtf8("opLine1TypeCombo"));

        gridLayout_43->addWidget(opLine1TypeCombo, 2, 1, 1, 1);

        opLine1SymDigitsSpin = new QSpinBox(opLine1Group);
        opLine1SymDigitsSpin->setObjectName(QString::fromUtf8("opLine1SymDigitsSpin"));

        gridLayout_43->addWidget(opLine1SymDigitsSpin, 3, 1, 1, 1);

        opLine1SymDigitsLabel = new QLabel(opLine1Group);
        opLine1SymDigitsLabel->setObjectName(QString::fromUtf8("opLine1SymDigitsLabel"));

        gridLayout_43->addWidget(opLine1SymDigitsLabel, 3, 0, 1, 1);


        gridLayout_42->addLayout(gridLayout_43, 0, 0, 1, 1);


        horizontalLayout_5->addWidget(opLine1Group);

        horizontalSpacer_6 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_5->addItem(horizontalSpacer_6);

        opLine2Group = new QGroupBox(opEdit);
        opLine2Group->setObjectName(QString::fromUtf8("opLine2Group"));
        gridLayout_45 = new QGridLayout(opLine2Group);
        gridLayout_45->setSpacing(6);
        gridLayout_45->setContentsMargins(6, 6, 6, 6);
        gridLayout_45->setObjectName(QString::fromUtf8("gridLayout_45"));
        gridLayout_40 = new QGridLayout();
        gridLayout_40->setSpacing(6);
        gridLayout_40->setObjectName(QString::fromUtf8("gridLayout_40"));
        gridLayout_40->setContentsMargins(-1, -1, -1, 4);
        opLine2WidthLabel = new QLabel(opLine2Group);
        opLine2WidthLabel->setObjectName(QString::fromUtf8("opLine2WidthLabel"));

        gridLayout_40->addWidget(opLine2WidthLabel, 0, 0, 1, 1);

        opLine2WidthSpin = new QSpinBox(opLine2Group);
        opLine2WidthSpin->setObjectName(QString::fromUtf8("opLine2WidthSpin"));
        opLine2WidthSpin->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        opLine2WidthSpin->setValue(2);

        gridLayout_40->addWidget(opLine2WidthSpin, 0, 1, 1, 1);

        opLine2ColorLabel = new QLabel(opLine2Group);
        opLine2ColorLabel->setObjectName(QString::fromUtf8("opLine2ColorLabel"));

        gridLayout_40->addWidget(opLine2ColorLabel, 1, 0, 1, 1);

        opLine2ColorCombo = new QComboBox(opLine2Group);
        opLine2ColorCombo->setObjectName(QString::fromUtf8("opLine2ColorCombo"));

        gridLayout_40->addWidget(opLine2ColorCombo, 1, 1, 1, 1);

        opLine2TypeLabel = new QLabel(opLine2Group);
        opLine2TypeLabel->setObjectName(QString::fromUtf8("opLine2TypeLabel"));

        gridLayout_40->addWidget(opLine2TypeLabel, 2, 0, 1, 1);

        opLine2TypeCombo = new QComboBox(opLine2Group);
        opLine2TypeCombo->setObjectName(QString::fromUtf8("opLine2TypeCombo"));

        gridLayout_40->addWidget(opLine2TypeCombo, 2, 1, 1, 1);

        opLine2SymDigitsSpin = new QSpinBox(opLine2Group);
        opLine2SymDigitsSpin->setObjectName(QString::fromUtf8("opLine2SymDigitsSpin"));

        gridLayout_40->addWidget(opLine2SymDigitsSpin, 3, 1, 1, 1);

        opLine2SymDigitsLabel = new QLabel(opLine2Group);
        opLine2SymDigitsLabel->setObjectName(QString::fromUtf8("opLine2SymDigitsLabel"));

        gridLayout_40->addWidget(opLine2SymDigitsLabel, 3, 0, 1, 1);


        gridLayout_45->addLayout(gridLayout_40, 0, 0, 1, 1);


        horizontalLayout_5->addWidget(opLine2Group);


        verticalLayout_11->addLayout(horizontalLayout_5);

        verticalSpacer_7 = new QSpacerItem(20, 20, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_11->addItem(verticalSpacer_7);

        modeStack->addWidget(opEdit);

        gridLayout_61->addWidget(modeStack, 1, 0, 1, 1);

        outputTab = new QTabWidget(layoutWidget);
        outputTab->setObjectName(QString::fromUtf8("outputTab"));
        outputTab->setMovable(true);
        outTextTab = new QWidget();
        outTextTab->setObjectName(QString::fromUtf8("outTextTab"));
        gridLayout = new QGridLayout(outTextTab);
        gridLayout->setSpacing(6);
        gridLayout->setContentsMargins(11, 11, 11, 11);
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        otEdit = new QTextEdit(outTextTab);
        otEdit->setObjectName(QString::fromUtf8("otEdit"));
        otEdit->setMinimumSize(QSize(400, 200));
        QFont font3;
        font3.setFamily(QString::fromUtf8("Courier New"));
        otEdit->setFont(font3);
        otEdit->setAutoFormatting(QTextEdit::AutoAll);

        gridLayout->addWidget(otEdit, 0, 0, 1, 1);

        outputTab->addTab(outTextTab, QString());
        outPlotTab = new QWidget();
        outPlotTab->setObjectName(QString::fromUtf8("outPlotTab"));
        gridLayout_76 = new QGridLayout(outPlotTab);
        gridLayout_76->setSpacing(6);
        gridLayout_76->setContentsMargins(11, 11, 11, 11);
        gridLayout_76->setObjectName(QString::fromUtf8("gridLayout_76"));
        outputPlotVLayout = new QVBoxLayout();
        outputPlotVLayout->setSpacing(6);
        outputPlotVLayout->setObjectName(QString::fromUtf8("outputPlotVLayout"));
        outputPlotHComboLayout = new QHBoxLayout();
        outputPlotHComboLayout->setSpacing(6);
        outputPlotHComboLayout->setObjectName(QString::fromUtf8("outputPlotHComboLayout"));
        outputPlotHComboLayout->setSizeConstraint(QLayout::SetMinimumSize);
        outputPlotTypeLabel = new QLabel(outPlotTab);
        outputPlotTypeLabel->setObjectName(QString::fromUtf8("outputPlotTypeLabel"));

        outputPlotHComboLayout->addWidget(outputPlotTypeLabel);

        outputPlotTypeCombo = new QComboBox(outPlotTab);
        outputPlotTypeCombo->setObjectName(QString::fromUtf8("outputPlotTypeCombo"));

        outputPlotHComboLayout->addWidget(outputPlotTypeCombo);

        horizontalSpacer_22 = new QSpacerItem(13, 17, QSizePolicy::Expanding, QSizePolicy::Minimum);

        outputPlotHComboLayout->addItem(horizontalSpacer_22);

        outputPlotRenderLabel = new QLabel(outPlotTab);
        outputPlotRenderLabel->setObjectName(QString::fromUtf8("outputPlotRenderLabel"));
        QSizePolicy sizePolicy11(QSizePolicy::Minimum, QSizePolicy::Minimum);
        sizePolicy11.setHorizontalStretch(0);
        sizePolicy11.setVerticalStretch(0);
        sizePolicy11.setHeightForWidth(outputPlotRenderLabel->sizePolicy().hasHeightForWidth());
        outputPlotRenderLabel->setSizePolicy(sizePolicy11);

        outputPlotHComboLayout->addWidget(outputPlotRenderLabel);

        outputPlotRenderCombo = new QComboBox(outPlotTab);
        outputPlotRenderCombo->setObjectName(QString::fromUtf8("outputPlotRenderCombo"));
        QSizePolicy sizePolicy12(QSizePolicy::Expanding, QSizePolicy::Minimum);
        sizePolicy12.setHorizontalStretch(0);
        sizePolicy12.setVerticalStretch(0);
        sizePolicy12.setHeightForWidth(outputPlotRenderCombo->sizePolicy().hasHeightForWidth());
        outputPlotRenderCombo->setSizePolicy(sizePolicy12);

        outputPlotHComboLayout->addWidget(outputPlotRenderCombo);


        outputPlotVLayout->addLayout(outputPlotHComboLayout);

        outputPlotHFrameLayout = new QHBoxLayout();
        outputPlotHFrameLayout->setSpacing(6);
        outputPlotHFrameLayout->setObjectName(QString::fromUtf8("outputPlotHFrameLayout"));
        outputPlotHFrameLayout->setSizeConstraint(QLayout::SetMaximumSize);
        outPlot = new QLabel(outPlotTab);
        outPlot->setObjectName(QString::fromUtf8("outPlot"));
        QSizePolicy sizePolicy13(QSizePolicy::MinimumExpanding, QSizePolicy::MinimumExpanding);
        sizePolicy13.setHorizontalStretch(0);
        sizePolicy13.setVerticalStretch(0);
        sizePolicy13.setHeightForWidth(outPlot->sizePolicy().hasHeightForWidth());
        outPlot->setSizePolicy(sizePolicy13);
        outPlot->setPixmap(QPixmap(QString::fromUtf8("../../../../../../.designer/QtRCommunications/gsdTest.jpg")));
        outPlot->setAlignment(Qt::AlignCenter);

        outputPlotHFrameLayout->addWidget(outPlot);


        outputPlotVLayout->addLayout(outputPlotHFrameLayout);


        gridLayout_76->addLayout(outputPlotVLayout, 0, 0, 1, 1);

        outputTab->addTab(outPlotTab, QString());

        gridLayout_61->addWidget(outputTab, 1, 1, 1, 1);

        gsDesign->setCentralWidget(gsDesignMainWidget);
        menuBar = new QMenuBar(gsDesign);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1338, 19));
        menuDesign = new QMenu(menuBar);
        menuDesign->setObjectName(QString::fromUtf8("menuDesign"));
        menuHelp = new QMenu(menuBar);
        menuHelp->setObjectName(QString::fromUtf8("menuHelp"));
        menuFile = new QMenu(menuBar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        menuGraph = new QMenu(menuBar);
        menuGraph->setObjectName(QString::fromUtf8("menuGraph"));
        gsDesign->setMenuBar(menuBar);
        statusBar = new QStatusBar(gsDesign);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        gsDesign->setStatusBar(statusBar);
        fileToolbar = new QToolBar(gsDesign);
        fileToolbar->setObjectName(QString::fromUtf8("fileToolbar"));
        fileToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
        gsDesign->addToolBar(Qt::TopToolBarArea, fileToolbar);
        designToolbar = new QToolBar(gsDesign);
        designToolbar->setObjectName(QString::fromUtf8("designToolbar"));
        designToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
        gsDesign->addToolBar(Qt::TopToolBarArea, designToolbar);
        outputToolbar = new QToolBar(gsDesign);
        outputToolbar->setObjectName(QString::fromUtf8("outputToolbar"));
        outputToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
        gsDesign->addToolBar(Qt::TopToolBarArea, outputToolbar);
        helpToolbar = new QToolBar(gsDesign);
        helpToolbar->setObjectName(QString::fromUtf8("helpToolbar"));
        helpToolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
        gsDesign->addToolBar(Qt::TopToolBarArea, helpToolbar);

        menuBar->addAction(menuFile->menuAction());
        menuBar->addAction(menuDesign->menuAction());
        menuBar->addAction(menuGraph->menuAction());
        menuBar->addAction(menuHelp->menuAction());
        menuDesign->addAction(menuActionNewDesign);
        menuDesign->addAction(menuActionDeleteDesign);
        menuDesign->addAction(menuActionDefaultDesign);
        menuDesign->addSeparator();
        menuDesign->addAction(menuActionRunDesign);
        menuHelp->addAction(menuActionOpenManual);
        menuHelp->addAction(menuActionContextHelp);
        menuHelp->addAction(menuActionAbout);
        menuFile->addAction(menuActionSaveDesign);
        menuFile->addAction(menuActionSaveAsDesign);
        menuFile->addAction(menuActionLoadDesign);
        menuFile->addSeparator();
        menuFile->addAction(menuActionExportDesign);
        menuFile->addAction(menuActionExportAllDesigns);
        menuFile->addSeparator();
        menuFile->addAction(menuActionChangeWorkingDirectory);
        menuFile->addSeparator();
        menuGraph->addAction(menuActionExportPlot);
        menuGraph->addAction(menuActionPlotDefaults);
        menuGraph->addSeparator();
        menuGraph->addAction(menuActionAutoscalePlot);
        fileToolbar->addAction(toolbarActionSaveDesign);
        fileToolbar->addAction(toolbarActionLoadDesign);
        designToolbar->addAction(toolbarActionNewDesign);
        designToolbar->addAction(toolbarActionDeleteDesign);
        designToolbar->addAction(toolbarActionDefaultDesign);
        designToolbar->addAction(toolbarActionExportDesign);
        designToolbar->addAction(toolbarActionRunDesign);
        outputToolbar->addAction(toolbarActionEditPlot);
        outputToolbar->addAction(toolbarActionExportPlot);

        retranslateUi(gsDesign);

        modeStack->setCurrentIndex(0);
        designTab->setCurrentIndex(1);
        eptSpacingCombo->setCurrentIndex(1);
        sampleSizeTab->setCurrentIndex(2);
        spendingFunctionTab->setCurrentIndex(1);
        sfl2PTab->setCurrentIndex(1);
        sfl3PTab->setCurrentIndex(1);
        sfu2PTab->setCurrentIndex(1);
        sfu3PTab->setCurrentIndex(1);
        sflTestCombo->setCurrentIndex(2);
        sflLBTCombo->setCurrentIndex(1);
        analysisTab->setCurrentIndex(0);
        outputTab->setCurrentIndex(1);


        QMetaObject::connectSlotsByName(gsDesign);
    } // setupUi

    void retranslateUi(QMainWindow *gsDesign)
    {
        gsDesign->setWindowTitle(QApplication::translate("gsDesign", "gsDesign", 0, QApplication::UnicodeUTF8));
        toolbarActionSaveDesign->setText(QApplication::translate("gsDesign", "Save", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionSaveDesign->setToolTip(QApplication::translate("gsDesign", "Save design(s) to file", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionLoadDesign->setText(QApplication::translate("gsDesign", "&Load ...", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        menuActionLoadDesign->setToolTip(QApplication::translate("gsDesign", "Load design file", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionLoadDesign->setText(QApplication::translate("gsDesign", "Load", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionLoadDesign->setToolTip(QApplication::translate("gsDesign", "Load design(s) from file", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionNewDesign->setText(QApplication::translate("gsDesign", "New", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionNewDesign->setToolTip(QApplication::translate("gsDesign", "Add new design", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionRunDesign->setText(QApplication::translate("gsDesign", "Run", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionRunDesign->setToolTip(QApplication::translate("gsDesign", "Execute design in R", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionRunDesign->setShortcut(QApplication::translate("gsDesign", "Ctrl+R", 0, QApplication::UnicodeUTF8));
        menuActionOpenManual->setText(QApplication::translate("gsDesign", "&Manual", 0, QApplication::UnicodeUTF8));
        menuActionContextHelp->setText(QApplication::translate("gsDesign", "&Context Help", 0, QApplication::UnicodeUTF8));
        menuActionAbout->setText(QApplication::translate("gsDesign", "&About gsDesign Explorer", 0, QApplication::UnicodeUTF8));
        toolbarActionContextHelp->setText(QApplication::translate("gsDesign", "Help", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionContextHelp->setToolTip(QApplication::translate("gsDesign", "Context Help", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionDefaultDesign->setText(QApplication::translate("gsDesign", "&Reset to Default Design", 0, QApplication::UnicodeUTF8));
        toolbarActionDeleteDesign->setText(QApplication::translate("gsDesign", "Delete", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionDeleteDesign->setToolTip(QApplication::translate("gsDesign", "Delete current design", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionSaveDesign->setText(QApplication::translate("gsDesign", "&Save", 0, QApplication::UnicodeUTF8));
        menuActionSaveAsDesign->setText(QApplication::translate("gsDesign", "&Save As ...", 0, QApplication::UnicodeUTF8));
        menuActionExportDesign->setText(QApplication::translate("gsDesign", "&Export Current Design ...", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        menuActionExportDesign->setToolTip(QApplication::translate("gsDesign", "Export", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionDefaultDesign->setText(QApplication::translate("gsDesign", "Default", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionDefaultDesign->setToolTip(QApplication::translate("gsDesign", "Reset design to default", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionNewDesign->setText(QApplication::translate("gsDesign", "&New Design", 0, QApplication::UnicodeUTF8));
        menuActionDeleteDesign->setText(QApplication::translate("gsDesign", "Delete Current Design", 0, QApplication::UnicodeUTF8));
        menuActionRunDesign->setText(QApplication::translate("gsDesign", "&Run Design", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        menuActionRunDesign->setToolTip(QApplication::translate("gsDesign", "Execute design in R", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionExportDesign->setText(QApplication::translate("gsDesign", "Export", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionExportDesign->setToolTip(QApplication::translate("gsDesign", "Export design to file", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionEditPlot->setText(QApplication::translate("gsDesign", "&Edit", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        menuActionEditPlot->setToolTip(QApplication::translate("gsDesign", "Edit plot parameters", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionExportPlot->setText(QApplication::translate("gsDesign", "&Export to File ...", 0, QApplication::UnicodeUTF8));
        toolbarActionEditPlot->setText(QApplication::translate("gsDesign", "Edit Plot", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionEditPlot->setToolTip(QApplication::translate("gsDesign", "Edit the current plot parameters", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionEditPlot->setShortcut(QApplication::translate("gsDesign", "Ctrl+E", 0, QApplication::UnicodeUTF8));
        toolbarActionExportPlot->setText(QApplication::translate("gsDesign", "Export Plot", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionExportPlot->setToolTip(QApplication::translate("gsDesign", "Export current plot to file", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        toolbarActionExportPlot->setShortcut(QApplication::translate("gsDesign", "Ctrl+E", 0, QApplication::UnicodeUTF8));
        menuActionChangeWorkingDirectory->setText(QApplication::translate("gsDesign", "&Change Working Directory ...", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        menuActionChangeWorkingDirectory->setToolTip(QApplication::translate("gsDesign", "Change working directory", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionExportAllDesigns->setText(QApplication::translate("gsDesign", "&Export All Designs ...", 0, QApplication::UnicodeUTF8));
        toolbarActionSetWorkingDirectory->setText(QApplication::translate("gsDesign", "Home", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        toolbarActionSetWorkingDirectory->setToolTip(QApplication::translate("gsDesign", "Change working directory", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionPlotDefaults->setText(QApplication::translate("gsDesign", "Use Default Settings", 0, QApplication::UnicodeUTF8));
        menuActionExit->setText(QApplication::translate("gsDesign", "&Quit gsDesignExplorer", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        menuActionExit->setToolTip(QApplication::translate("gsDesign", "Exit gsDesign Explorer", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        menuActionAutoscalePlot->setText(QApplication::translate("gsDesign", "&Autoscale", 0, QApplication::UnicodeUTF8));
        dnGroup->setTitle(QApplication::translate("gsDesign", "Design Navigator", 0, QApplication::UnicodeUTF8));
        dnModeCombo->clear();
        dnModeCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Design", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Analysis", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Simulation", 0, QApplication::UnicodeUTF8)
        );
        dnNameCombo->clear();
        dnNameCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Design1", 0, QApplication::UnicodeUTF8)
        );
#ifndef QT_NO_TOOLTIP
        dnNameCombo->setToolTip(QApplication::translate("gsDesign", "Press enter to confirm", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
        dnDescCombo->clear();
        dnDescCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Design1 description ...", 0, QApplication::UnicodeUTF8)
        );
        eptErrorPowerGroup->setTitle(QApplication::translate("gsDesign", "Type I Error and Power", 0, QApplication::UnicodeUTF8));
        eptErrorLabel->setText(QApplication::translate("gsDesign", "Type I Error (1-sided \316\261 x 100)", 0, QApplication::UnicodeUTF8));
        eptErrorDSpin->setProperty("suffix", QVariant(QApplication::translate("gsDesign", " %", 0, QApplication::UnicodeUTF8)));
        eptPowerLabel->setText(QApplication::translate("gsDesign", "Power (100 x [1 -\316\262])", 0, QApplication::UnicodeUTF8));
        eptPowerDSpin->setProperty("suffix", QVariant(QApplication::translate("gsDesign", " %", 0, QApplication::UnicodeUTF8)));
        tdTimingGroup->setTitle(QApplication::translate("gsDesign", "Timing of interim analyses", 0, QApplication::UnicodeUTF8));
        eptIntervalsLabel->setText(QApplication::translate("gsDesign", "Number of Interim Analyses", 0, QApplication::UnicodeUTF8));
        eptSpacingLabel->setText(QApplication::translate("gsDesign", "Spacing", 0, QApplication::UnicodeUTF8));
        eptSpacingCombo->clear();
        eptSpacingCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Equal", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Unequal", 0, QApplication::UnicodeUTF8)
        );
        eptSpacingLabel_2->setText(QString());
        QTableWidgetItem *___qtablewidgetitem = eptTimingTable->horizontalHeaderItem(0);
        ___qtablewidgetitem->setText(QApplication::translate("gsDesign", "Timing", 0, QApplication::UnicodeUTF8));

        const bool __sortingEnabled = eptTimingTable->isSortingEnabled();
        eptTimingTable->setSortingEnabled(false);
        eptTimingTable->setSortingEnabled(__sortingEnabled);

        designTab->setTabText(designTab->indexOf(eptTab), QApplication::translate("gsDesign", "\316\261 \342\200\242 Power \342\200\242 Timing", 0, QApplication::UnicodeUTF8));
        ssUserFixedLabel->setText(QApplication::translate("gsDesign", "Fixed Design Sample Size", 0, QApplication::UnicodeUTF8));
        sampleSizeTab->setTabText(sampleSizeTab->indexOf(ssUserTab), QApplication::translate("gsDesign", "User Input", 0, QApplication::UnicodeUTF8));
        ssBinEventGroup->setTitle(QApplication::translate("gsDesign", "Event Rates", 0, QApplication::UnicodeUTF8));
        ssBinRatioLabel->setText(QApplication::translate("gsDesign", "Randomization Ratio", 0, QApplication::UnicodeUTF8));
        ssBinControlLabel->setText(QApplication::translate("gsDesign", "Control", 0, QApplication::UnicodeUTF8));
        ssBinExpLabel->setText(QApplication::translate("gsDesign", "Experimental", 0, QApplication::UnicodeUTF8));
        ssBinTestingGroup->setTitle(QApplication::translate("gsDesign", "Testing", 0, QApplication::UnicodeUTF8));
        ssBinSupCombo->clear();
        ssBinSupCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Superiority", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Non-inferiority/sup with margin", 0, QApplication::UnicodeUTF8)
        );
        ssBinDeltaLabel->setText(QApplication::translate("gsDesign", "Delta", 0, QApplication::UnicodeUTF8));
        groupBox_3->setTitle(QApplication::translate("gsDesign", "Fixed Design", 0, QApplication::UnicodeUTF8));
        ssBinSSLabel->setText(QApplication::translate("gsDesign", "Sample Size", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        ssBinFixedSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sampleSizeTab->setTabText(sampleSizeTab->indexOf(ssBinTab), QApplication::translate("gsDesign", "Binomial", 0, QApplication::UnicodeUTF8));
        ssTEAccrualGroup->setTitle(QApplication::translate("gsDesign", "Accrual ", 0, QApplication::UnicodeUTF8));
        ssTEAccrualCombo->clear();
        ssTEAccrualCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Uniform", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Exponential", 0, QApplication::UnicodeUTF8)
        );
        ssTEGammaLabel->setText(QApplication::translate("gsDesign", "Gamma", 0, QApplication::UnicodeUTF8));
        ssTEOtherGroup->setTitle(QApplication::translate("gsDesign", "Other Event Parameters", 0, QApplication::UnicodeUTF8));
        ssTEAccrualLabel->setText(QApplication::translate("gsDesign", "Accrual Duration", 0, QApplication::UnicodeUTF8));
        ssTEFollowLabel->setText(QApplication::translate("gsDesign", "Minimum Follow-Up", 0, QApplication::UnicodeUTF8));
        ssTERatioLabel->setText(QApplication::translate("gsDesign", "Randomization Ratio", 0, QApplication::UnicodeUTF8));
        ssTEHypLabel->setText(QApplication::translate("gsDesign", "Hypothesis", 0, QApplication::UnicodeUTF8));
        ssTEHypCombo->clear();
        ssTEHypCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Risk Ratio", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Risk Difference", 0, QApplication::UnicodeUTF8)
        );
        groupBox->setTitle(QApplication::translate("gsDesign", "Fixed Design", 0, QApplication::UnicodeUTF8));
        ssTEFixedLabel->setText(QApplication::translate("gsDesign", "Sample Size", 0, QApplication::UnicodeUTF8));
        ssTEFixedEventLabel->setText(QApplication::translate("gsDesign", "Events", 0, QApplication::UnicodeUTF8));
        ssTEGroup->setTitle(QApplication::translate("gsDesign", "Event rates/Median Times to Events", 0, QApplication::UnicodeUTF8));
        ssTESwitchCombo->clear();
        ssTESwitchCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Event Rate", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Median Time", 0, QApplication::UnicodeUTF8)
        );
        ssTECtrlLabel->setText(QApplication::translate("gsDesign", "Control", 0, QApplication::UnicodeUTF8));
        ssTEExpLabel->setText(QApplication::translate("gsDesign", "Experimental", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("gsDesign", "Specification", 0, QApplication::UnicodeUTF8));
        ssTEDropoutLabel->setText(QApplication::translate("gsDesign", "Dropout", 0, QApplication::UnicodeUTF8));
        ssTEHazardRatioLabel->setText(QApplication::translate("gsDesign", "Hazard Ratio", 0, QApplication::UnicodeUTF8));
        sampleSizeTab->setTabText(sampleSizeTab->indexOf(ssTETab), QApplication::translate("gsDesign", "Time to Event", 0, QApplication::UnicodeUTF8));
        designTab->setTabText(designTab->indexOf(ss), QApplication::translate("gsDesign", "Sample Size", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_WHATSTHIS
        sflParamToolBox->setWhatsThis(QString());
#endif // QT_NO_WHATSTHIS
        sfl0PCombo->clear();
        sfl0PCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "O'Brien-Fleming", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Pocock", 0, QApplication::UnicodeUTF8)
        );
        sfl0PLabel->setText(QApplication::translate("gsDesign", "Lan-DeMets Approximation", 0, QApplication::UnicodeUTF8));
        sflParamToolBox->setItemText(sflParamToolBox->indexOf(LParameterFree), QApplication::translate("gsDesign", "Parameter Free", 0, QApplication::UnicodeUTF8));
        sfl1PCombo->clear();
        sfl1PCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Hwang-Shih-DeCani", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Power", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Exponential", 0, QApplication::UnicodeUTF8)
        );
        sfl1PDSpin->setProperty("specialValueText", QVariant(QString()));
        sflParamToolBox->setItemText(sflParamToolBox->indexOf(LOneParameter), QApplication::translate("gsDesign", "1-Parameter", 0, QApplication::UnicodeUTF8));
        sfl2PFunLabel->setText(QApplication::translate("gsDesign", "Function", 0, QApplication::UnicodeUTF8));
        sfl2PFunCombo->clear();
        sfl2PFunCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Beta Distribution", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Cauchy", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Extreme Value", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Extreme Value (2)", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Logistic", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Normal", 0, QApplication::UnicodeUTF8)
        );
        sfl2PPt1Group->setTitle(QApplication::translate("gsDesign", "Point 1", 0, QApplication::UnicodeUTF8));
        sfl2PPt1XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl2PPt1XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl2PPt1YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl2PPt1YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl2PPt2Group->setTitle(QApplication::translate("gsDesign", "Point 2", 0, QApplication::UnicodeUTF8));
        sfl2PPt2XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl2PPt2XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl2PPt2YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl2PPt2YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl2PTab->setTabText(sfl2PTab->indexOf(sfl2PFunTab), QApplication::translate("gsDesign", "Points", 0, QApplication::UnicodeUTF8));
        sfl2PLMSlpLabel->setText(QApplication::translate("gsDesign", "Slope", 0, QApplication::UnicodeUTF8));
        sfl2PLMIntLabel->setText(QApplication::translate("gsDesign", "Intercept", 0, QApplication::UnicodeUTF8));
        sfl2PTab->setTabText(sfl2PTab->indexOf(sfl2PLMTab), QApplication::translate("gsDesign", "Slope \342\200\242 Intercept", 0, QApplication::UnicodeUTF8));
        sflParamToolBox->setItemText(sflParamToolBox->indexOf(LTwoParameter), QApplication::translate("gsDesign", "2-Parameter", 0, QApplication::UnicodeUTF8));
        sfl3PPt1Group->setTitle(QApplication::translate("gsDesign", "Point 1", 0, QApplication::UnicodeUTF8));
        sfl3PPt1XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl3PPt1XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl3PPt1YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl3PPt1YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl3PPt2Group->setTitle(QApplication::translate("gsDesign", "Point 2", 0, QApplication::UnicodeUTF8));
        sfl3PPt2XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl3PPt2XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl3PPt2YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfl3PPt2YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfl3PPtsDfLabel->setText(QApplication::translate("gsDesign", "df", 0, QApplication::UnicodeUTF8));
        sfl3PTab->setTabText(sfl3PTab->indexOf(sfl3PPtsTab), QApplication::translate("gsDesign", "Points", 0, QApplication::UnicodeUTF8));
        sfl3PLMSlpLayer->setText(QApplication::translate("gsDesign", "Slope", 0, QApplication::UnicodeUTF8));
        sfl3PLMIntLabel->setText(QApplication::translate("gsDesign", "Intercept", 0, QApplication::UnicodeUTF8));
        sfl3PLMDfLabel->setText(QApplication::translate("gsDesign", "df", 0, QApplication::UnicodeUTF8));
        sfl3PTab->setTabText(sfl3PTab->indexOf(sfl3PLMTab), QApplication::translate("gsDesign", "Slope \342\200\242 Intercept \342\200\242 df", 0, QApplication::UnicodeUTF8));
        sflParamToolBox->setItemText(sflParamToolBox->indexOf(LThreeParameter), QApplication::translate("gsDesign", "3-Parameter", 0, QApplication::UnicodeUTF8));
        sflPiecePtsLabel->setText(QApplication::translate("gsDesign", " Points", 0, QApplication::UnicodeUTF8));
        sflPieceUseInterimRadio->setText(QApplication::translate("gsDesign", "Use interim timing  ", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem1 = sflPieceTableX->horizontalHeaderItem(0);
        ___qtablewidgetitem1->setText(QApplication::translate("gsDesign", "X", 0, QApplication::UnicodeUTF8));

        const bool __sortingEnabled1 = sflPieceTableX->isSortingEnabled();
        sflPieceTableX->setSortingEnabled(false);
        sflPieceTableX->setSortingEnabled(__sortingEnabled1);

        QTableWidgetItem *___qtablewidgetitem2 = sflPieceTableY->horizontalHeaderItem(0);
        ___qtablewidgetitem2->setText(QApplication::translate("gsDesign", "Y", 0, QApplication::UnicodeUTF8));

        const bool __sortingEnabled2 = sflPieceTableY->isSortingEnabled();
        sflPieceTableY->setSortingEnabled(false);
        sflPieceTableY->setSortingEnabled(__sortingEnabled2);

        sflParamToolBox->setItemText(sflParamToolBox->indexOf(LPiecewiseLinear), QApplication::translate("gsDesign", "Piecewise Linear", 0, QApplication::UnicodeUTF8));
        spendingFunctionTab->setTabText(spendingFunctionTab->indexOf(sflTab), QApplication::translate("gsDesign", "Lower Spending", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_WHATSTHIS
        sfuParamToolBox->setWhatsThis(QString());
#endif // QT_NO_WHATSTHIS
        sfu0PCombo->clear();
        sfu0PCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "O'Brien-Fleming", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Pocock", 0, QApplication::UnicodeUTF8)
        );
        sfu0PLabel->setText(QApplication::translate("gsDesign", "Lan-DeMets Approximation", 0, QApplication::UnicodeUTF8));
        sfuParamToolBox->setItemText(sfuParamToolBox->indexOf(UParameterFree), QApplication::translate("gsDesign", "Parameter Free", 0, QApplication::UnicodeUTF8));
        sfu1PCombo->clear();
        sfu1PCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Hwang-Shih-DeCani", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Power", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Exponential", 0, QApplication::UnicodeUTF8)
        );
        sfu1PDSpin->setProperty("specialValueText", QVariant(QString()));
        sfuParamToolBox->setItemText(sfuParamToolBox->indexOf(UOneParameter), QApplication::translate("gsDesign", "1-Parameter", 0, QApplication::UnicodeUTF8));
        sfu2PFunLabel->setText(QApplication::translate("gsDesign", "Function", 0, QApplication::UnicodeUTF8));
        sfu2PFunCombo->clear();
        sfu2PFunCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Beta Distribution", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Cauchy", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Extreme Value", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Extreme Value (2)", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Logistic", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Normal", 0, QApplication::UnicodeUTF8)
        );
        sfu2PPt1Group->setTitle(QApplication::translate("gsDesign", "Point 1", 0, QApplication::UnicodeUTF8));
        sfu2PPt1XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu2PPt1XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu2PPt1YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu2PPt1YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu2PPt2Group->setTitle(QApplication::translate("gsDesign", "Point 2", 0, QApplication::UnicodeUTF8));
        sfu2PPt2XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu2PPt2XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu2PPt2YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu2PPt2YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu2PTab->setTabText(sfu2PTab->indexOf(sfu2P), QApplication::translate("gsDesign", "Points", 0, QApplication::UnicodeUTF8));
        sfu2PLMSlpLabel->setText(QApplication::translate("gsDesign", "Slope", 0, QApplication::UnicodeUTF8));
        sfu2PLMIntLabel->setText(QApplication::translate("gsDesign", "Intercept", 0, QApplication::UnicodeUTF8));
        sfu2PTab->setTabText(sfu2PTab->indexOf(sfl2PLMTab_2), QApplication::translate("gsDesign", "Slope \342\200\242 Intercept", 0, QApplication::UnicodeUTF8));
        sfuParamToolBox->setItemText(sfuParamToolBox->indexOf(UTwoParameter), QApplication::translate("gsDesign", "2-Parameter", 0, QApplication::UnicodeUTF8));
        sfu3PPt1Group->setTitle(QApplication::translate("gsDesign", "Point 1", 0, QApplication::UnicodeUTF8));
        sfu3PPt1XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu3PPt1XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu3PPt1YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu3PPt1YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu3PPt2Group->setTitle(QApplication::translate("gsDesign", "Point 2", 0, QApplication::UnicodeUTF8));
        sfu3PPt2XLabel->setText(QApplication::translate("gsDesign", "x", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu3PPt2XDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu3PPt2YLabel->setText(QApplication::translate("gsDesign", "y", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        sfu3PPt2YDSpin->setToolTip(QString());
#endif // QT_NO_TOOLTIP
        sfu3PPtsDfLabel->setText(QApplication::translate("gsDesign", "df", 0, QApplication::UnicodeUTF8));
        sfu3PTab->setTabText(sfu3PTab->indexOf(sfu3PPts), QApplication::translate("gsDesign", "Points", 0, QApplication::UnicodeUTF8));
        sfu3PLMSlpLabel->setText(QApplication::translate("gsDesign", "Slope", 0, QApplication::UnicodeUTF8));
        sfu3PLMIntLabel->setText(QApplication::translate("gsDesign", "Intercept", 0, QApplication::UnicodeUTF8));
        sfu3PLMDfLabel->setText(QApplication::translate("gsDesign", "df", 0, QApplication::UnicodeUTF8));
        sfu3PTab->setTabText(sfu3PTab->indexOf(sfu3PLMTab), QApplication::translate("gsDesign", "Slope \342\200\242 Intercept \342\200\242 df", 0, QApplication::UnicodeUTF8));
        sfuParamToolBox->setItemText(sfuParamToolBox->indexOf(UThreeParameter), QApplication::translate("gsDesign", "3-Parameter", 0, QApplication::UnicodeUTF8));
        sfuPiecePtsLabel->setText(QApplication::translate("gsDesign", " Points", 0, QApplication::UnicodeUTF8));
        sfuPieceUseInterimRadio->setText(QApplication::translate("gsDesign", "Use Interim Timing  ", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem3 = sfuPieceTableX->horizontalHeaderItem(0);
        ___qtablewidgetitem3->setText(QApplication::translate("gsDesign", "X", 0, QApplication::UnicodeUTF8));

        const bool __sortingEnabled3 = sfuPieceTableX->isSortingEnabled();
        sfuPieceTableX->setSortingEnabled(false);
        sfuPieceTableX->setSortingEnabled(__sortingEnabled3);

        QTableWidgetItem *___qtablewidgetitem4 = sfuPieceTableY->horizontalHeaderItem(0);
        ___qtablewidgetitem4->setText(QApplication::translate("gsDesign", "Y", 0, QApplication::UnicodeUTF8));

        const bool __sortingEnabled4 = sfuPieceTableY->isSortingEnabled();
        sfuPieceTableY->setSortingEnabled(false);
        sfuPieceTableY->setSortingEnabled(__sortingEnabled4);

        sfuParamToolBox->setItemText(sfuParamToolBox->indexOf(UPiecewiseLinear), QApplication::translate("gsDesign", "Piecewise Linear", 0, QApplication::UnicodeUTF8));
        tdTestingBox->setTitle(QApplication::translate("gsDesign", "Testing", 0, QApplication::UnicodeUTF8));
        sflTestLabel->setText(QApplication::translate("gsDesign", "Test Type", 0, QApplication::UnicodeUTF8));
        sflTestCombo->clear();
        sflTestCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "1-sided", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "2-sided symmetric", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "2-sided with futility", 0, QApplication::UnicodeUTF8)
        );
#ifndef QT_NO_WHATSTHIS
        sflTestCombo->setWhatsThis(QString());
#endif // QT_NO_WHATSTHIS
        sflLBSLabel->setText(QApplication::translate("gsDesign", "Lower Bound Spending", 0, QApplication::UnicodeUTF8));
        sflLBSCombo->clear();
        sflLBSCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Beta-spending", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "H0 spending", 0, QApplication::UnicodeUTF8)
        );
        sflLBTLabel->setText(QApplication::translate("gsDesign", "Lower Bound Testing", 0, QApplication::UnicodeUTF8));
        sflLBTCombo->clear();
        sflLBTCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Binding", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Non-binding", 0, QApplication::UnicodeUTF8)
        );
        spendingFunctionTab->setTabText(spendingFunctionTab->indexOf(sfuTab), QApplication::translate("gsDesign", "Upper Spending", 0, QApplication::UnicodeUTF8));
        designTab->setTabText(designTab->indexOf(sf), QApplication::translate("gsDesign", "Spending Functions", 0, QApplication::UnicodeUTF8));
        anlErrorPowerSampleGroup->setTitle(QApplication::translate("gsDesign", "Error and Power", 0, QApplication::UnicodeUTF8));
        anlErrorLabel->setText(QApplication::translate("gsDesign", "Type I Error (1-sided % \316\261)", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_WHATSTHIS
        anlErrorDSpin->setWhatsThis(QApplication::translate("gsDesign", "Type I Error ", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_WHATSTHIS
        anlErrorDSpin->setProperty("suffix", QVariant(QApplication::translate("gsDesign", " %", 0, QApplication::UnicodeUTF8)));
        anlPowerLabel->setText(QApplication::translate("gsDesign", "Planned Power (% [1 -\316\262])", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_WHATSTHIS
        anlPowerDSpin->setWhatsThis(QApplication::translate("gsDesign", "Type II Error", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_WHATSTHIS
        anlPowerDSpin->setProperty("suffix", QVariant(QApplication::translate("gsDesign", " %", 0, QApplication::UnicodeUTF8)));
        analSampleSizeGroup->setTitle(QApplication::translate("gsDesign", "Maximum Sample Size", 0, QApplication::UnicodeUTF8));
        anlMaxSampleSizeLabel->setText(QApplication::translate("gsDesign", "Number of Analyses", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_WHATSTHIS
        anlMaxSampleSizeSpin->setWhatsThis(QApplication::translate("gsDesign", "Sample size", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_WHATSTHIS
        QTableWidgetItem *___qtablewidgetitem5 = anlSampleSizeTable->horizontalHeaderItem(0);
        ___qtablewidgetitem5->setText(QApplication::translate("gsDesign", "n at analyses", 0, QApplication::UnicodeUTF8));

        const bool __sortingEnabled5 = anlSampleSizeTable->isSortingEnabled();
        anlSampleSizeTable->setSortingEnabled(false);
        QTableWidgetItem *___qtablewidgetitem6 = anlSampleSizeTable->item(0, 0);
        ___qtablewidgetitem6->setText(QApplication::translate("gsDesign", "-1", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem7 = anlSampleSizeTable->item(1, 0);
        ___qtablewidgetitem7->setText(QApplication::translate("gsDesign", "-1", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem8 = anlSampleSizeTable->item(2, 0);
        ___qtablewidgetitem8->setText(QApplication::translate("gsDesign", "-1", 0, QApplication::UnicodeUTF8));
        anlSampleSizeTable->setSortingEnabled(__sortingEnabled5);

#ifndef QT_NO_WHATSTHIS
        anlSampleSizeTable->setWhatsThis(QApplication::translate("gsDesign", "Sample size per analysis", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_WHATSTHIS
        anlLockTimesRadio->setText(QApplication::translate("gsDesign", "Lock Analysis Times", 0, QApplication::UnicodeUTF8));
        groupBox_4->setTitle(QApplication::translate("gsDesign", "Planned Final n", 0, QApplication::UnicodeUTF8));
        analysisTab->setTabText(analysisTab->indexOf(epss), QApplication::translate("gsDesign", "\316\261 \342\200\242 Power \342\200\242 Maximum Sample Size", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("gsDesign", "For future implementation", 0, QApplication::UnicodeUTF8));
        groupBox_2->setTitle(QApplication::translate("gsDesign", "Plot Navigator", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("gsDesign", "Plot Type", 0, QApplication::UnicodeUTF8));
        opTypeCombo->clear();
        opTypeCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Boundaries", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Power", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Treatment Effect", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Conditional Power", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Spending Function", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Expected Sample Size", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "B-Values", 0, QApplication::UnicodeUTF8)
        );
        opPlotRenderLabel->setText(QApplication::translate("gsDesign", "Rendering", 0, QApplication::UnicodeUTF8));
        opPlotRenderCombo->clear();
        opPlotRenderCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Basic graphics (high-speed)", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "High quality (slow-speed)", 0, QApplication::UnicodeUTF8)
        );
        opLabelsGroup->setTitle(QApplication::translate("gsDesign", "Labels", 0, QApplication::UnicodeUTF8));
        opTitleLabel->setText(QApplication::translate("gsDesign", "Title", 0, QApplication::UnicodeUTF8));
        opXLabelLabel->setText(QApplication::translate("gsDesign", "x-axis", 0, QApplication::UnicodeUTF8));
        opYLabelLeftLabel->setText(QApplication::translate("gsDesign", "y-axis", 0, QApplication::UnicodeUTF8));
        opLine1Group->setTitle(QApplication::translate("gsDesign", "Point/Line Plot 1", 0, QApplication::UnicodeUTF8));
        opLine1WidthLabel->setText(QApplication::translate("gsDesign", "Line width", 0, QApplication::UnicodeUTF8));
        opLine1ColorLabel->setText(QApplication::translate("gsDesign", "Color", 0, QApplication::UnicodeUTF8));
        opLine1ColorCombo->clear();
        opLine1ColorCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "black", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "red", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "green", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "blue", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "cyan", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "magenta", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "yellow", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "gray", 0, QApplication::UnicodeUTF8)
        );
        opLine1TypeLabel->setText(QApplication::translate("gsDesign", "Line type", 0, QApplication::UnicodeUTF8));
        opLine1TypeCombo->clear();
        opLine1TypeCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "solid", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "dashed", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "dotted", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "dotdash", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "longdash", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "twodash", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "blank", 0, QApplication::UnicodeUTF8)
        );
        opLine1SymDigitsLabel->setText(QApplication::translate("gsDesign", "Text digits", 0, QApplication::UnicodeUTF8));
        opLine2Group->setTitle(QApplication::translate("gsDesign", "Point/Line Plot 2", 0, QApplication::UnicodeUTF8));
        opLine2WidthLabel->setText(QApplication::translate("gsDesign", "Line width", 0, QApplication::UnicodeUTF8));
        opLine2ColorLabel->setText(QApplication::translate("gsDesign", "Color", 0, QApplication::UnicodeUTF8));
        opLine2ColorCombo->clear();
        opLine2ColorCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "black", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "red", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "green", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "blue", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "cyan", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "magenta", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "yellow", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "gray", 0, QApplication::UnicodeUTF8)
        );
        opLine2TypeLabel->setText(QApplication::translate("gsDesign", "Line type", 0, QApplication::UnicodeUTF8));
        opLine2TypeCombo->clear();
        opLine2TypeCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "solid", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "dashed", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "dotted", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "dotdash", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "longdash", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "twodash", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "blank", 0, QApplication::UnicodeUTF8)
        );
        opLine2SymDigitsLabel->setText(QApplication::translate("gsDesign", "Text digits", 0, QApplication::UnicodeUTF8));
        outputTab->setTabText(outputTab->indexOf(outTextTab), QApplication::translate("gsDesign", "Text", 0, QApplication::UnicodeUTF8));
        outputPlotTypeLabel->setText(QApplication::translate("gsDesign", "Plot Type", 0, QApplication::UnicodeUTF8));
        outputPlotTypeCombo->clear();
        outputPlotTypeCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Boundaries", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Power", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Treatment Effect", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Conditional Power", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Spending Function", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "Expected Sample Size", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "B-Values", 0, QApplication::UnicodeUTF8)
        );
        outputPlotRenderLabel->setText(QApplication::translate("gsDesign", "Rendering", 0, QApplication::UnicodeUTF8));
        outputPlotRenderCombo->clear();
        outputPlotRenderCombo->insertItems(0, QStringList()
         << QApplication::translate("gsDesign", "Basic Graphics (high-speed)", 0, QApplication::UnicodeUTF8)
         << QApplication::translate("gsDesign", "High quality (slow-speed)", 0, QApplication::UnicodeUTF8)
        );
        outPlot->setText(QString());
        outputTab->setTabText(outputTab->indexOf(outPlotTab), QApplication::translate("gsDesign", "Plot", 0, QApplication::UnicodeUTF8));
        menuDesign->setTitle(QApplication::translate("gsDesign", "&Design", 0, QApplication::UnicodeUTF8));
        menuHelp->setTitle(QApplication::translate("gsDesign", "&Help", 0, QApplication::UnicodeUTF8));
        menuFile->setTitle(QApplication::translate("gsDesign", "&File", 0, QApplication::UnicodeUTF8));
        menuGraph->setTitle(QApplication::translate("gsDesign", "&Plot", 0, QApplication::UnicodeUTF8));
        fileToolbar->setWindowTitle(QApplication::translate("gsDesign", "Design Toolbar", 0, QApplication::UnicodeUTF8));
#ifndef QT_NO_TOOLTIP
        fileToolbar->setToolTip(QApplication::translate("gsDesign", "Design Toolbar", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_TOOLTIP
#ifndef QT_NO_ACCESSIBILITY
        fileToolbar->setAccessibleName(QApplication::translate("gsDesign", "Design Toolbar", 0, QApplication::UnicodeUTF8));
#endif // QT_NO_ACCESSIBILITY
        designToolbar->setWindowTitle(QApplication::translate("gsDesign", "toolBar", 0, QApplication::UnicodeUTF8));
        outputToolbar->setWindowTitle(QApplication::translate("gsDesign", "toolBar", 0, QApplication::UnicodeUTF8));
        helpToolbar->setWindowTitle(QApplication::translate("gsDesign", "toolBar", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class gsDesign: public Ui_gsDesign {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GSDESIGN_H
