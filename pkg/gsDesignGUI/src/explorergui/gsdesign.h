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

#ifndef GSDESIGN_H
#define GSDESIGN_H

#include <QAction>
#include <QComboBox>
#include <QDesktopServices>
#include <QFileDialog>
#include <QMainWindow>
#include <QMap>
#include <QMessageBox>
#include <QRadioButton>
#include <QSpinBox>
#include <QSplashScreen>
#include <QTableWidget>
#include <QTimer>
#include <QToolBox>
#include <QUrl>
#include <QWhatsThis>
#include <QDesktopWidget>
#include <QEvent>
#include <QKeyEvent>
#include "qdslider.h"

namespace Ui {
    class gsDesign;
}

class gsDesign : public QMainWindow {
    Q_OBJECT
public:
    gsDesign(QWidget *parent = 0);
    ~gsDesign();
    enum Spending { LowerSpending, UpperSpending };
    enum MapAction { setMap, getMap };

protected:
    void changeEvent(QEvent *e);
    bool eventFilter(QObject *o, QEvent *e);

private slots:
    void populatePlotFromDesignQMap();
    void fillAnalysisTable(double *array, int len);
    bool validatePiecewiseTables();
    bool isValidPiecewiseTable(QTableWidget *table, QSpinBox *spin, int *emptyIndex);
    double convertEventRate(double val);
    void dnDescCombo_returnPressed();
    void dnNameCombo_returnPressed();
    void on_menuActionAutoscalePlot_toggled(bool );
    void quit();
    void on_menuActionExit_triggered();
    void on_opYLabelLeftLine_editingFinished();
    void on_opXLabelLine_editingFinished();
    void on_opTitleLine_editingFinished();
    void on_opPlotRenderCombo_currentIndexChanged(int index);
    void on_menuActionPlotDefaults_triggered();
    void informationHandler(QString information);
    void warningHandler(QString warning);
    void errorHandler(QString error);
    bool exportAllDesigns();
    void on_menuActionExportAllDesigns_triggered();
    void on_toolbarActionSetWorkingDirectory_triggered();
    bool setWorkingDirectory();
    void on_menuActionChangeWorkingDirectory_triggered();
    void on_toolbarActionEditPlot_triggered();
    void on_menuActionExportPlot_triggered();
    void exportPlot();
    void on_toolbarActionExportPlot_triggered();
    QMap<QString, QString> updateDesignMap();
    QString QComboBoxIndexToQString(QComboBox *combo);
    QString QDoubleSpinBoxValueToQString(QDoubleSpinBox *dspin);
    QString QSpinBoxValueToQString(QSpinBox *spin);
    QString QTableWidgetToQString(QTableWidget *table);
    QString strippedName(const QString &fullFileName);
    bool exportDesign();
    bool save();
    bool saveAs();
    bool saveFile(const QString &fileName);
    bool writeFile(const QString &fileName);
    void about();
    void addNewDesign();
    void contextHelp();
    void deleteDesign();
    void designMapToQComboBox(QComboBox *combo);
    void designMapToQDoubleSpinBox(QDoubleSpinBox *dspin);
    void designMapToQRadioButton(QRadioButton *radio);
    void designMapToQSpinBox(QSpinBox *spin);
    void designMapToQTabWidget(QTabWidget *tab);
    void designMapToQTableWidget(QTableWidget *table);
    void designMapToQToolBox(QToolBox *page);
    void displayImage();
    void enableAllWidgets(bool enable);
    void featureNotComplete();
    void fillTimingTable();
    void formatTable(QTableWidget *table, double minimum, double maximum);
    void getPlotQMapPointer(QString type, QMap<QString, QString> **plot);
    void initialize1ParamSpending(QComboBox *combo, QDoubleSpinBox *param, gsDesign::Spending spending);
    void loadDesign();
    void loadFile(QString &fileName);
    void on_anlErrorDSpin_valueChanged();
    void on_anlMaxSampleSizeSpin_valueChanged(int );
    void on_anlPowerDSpin_valueChanged();
    void on_anlSampleSizeTable_cellChanged(int, int);
    void on_designTab_currentChanged(int );
    void on_dnDescCombo_textChanged(QString );
    void on_dnModeCombo_currentIndexChanged(QString );
    void on_dnNameCombo_currentIndexChanged(int );
    void on_dnNameCombo_textChanged(QString );
    void on_eptErrorDSpin_valueChanged();
    void on_eptIntervalsSpin_valueChanged(int );
    void on_eptPowerDSpin_valueChanged();
    void on_eptSpacingCombo_currentIndexChanged(int );
    void on_eptTimingTable_cellChanged(int, int );
    void on_menuActionAbout_triggered();
    void on_menuActionContextHelp_triggered();
    void on_menuActionDefaultDesign_triggered();
    void on_menuActionDeleteDesign_triggered();
    void on_menuActionExportDesign_triggered();
    void on_menuActionLoadDesign_triggered();
    void on_menuActionNewDesign_triggered();
    void on_menuActionOpenManual_triggered();
    void on_menuActionRunDesign_triggered();
    void on_menuActionSaveAsDesign_triggered();
    void on_menuActionSaveDesign_triggered();
    void on_opLine1ColorCombo_currentIndexChanged(int index);
    void on_opLine1SymDigitsSpin_valueChanged(QString text);
    void on_opLine1TypeCombo_currentIndexChanged(int index);
    void on_opLine1WidthSpin_valueChanged(QString );
    void on_opLine2ColorCombo_currentIndexChanged(int index);
    void on_opLine2SymDigitsSpin_valueChanged(QString text);
    void on_opLine2TypeCombo_currentIndexChanged(int index);
    void on_opLine2WidthSpin_valueChanged(QString );
    void on_opTitleLine_textChanged(QString );
    void on_opTypeCombo_currentIndexChanged();
    void on_opXLabelLine_textChanged(QString );
    void on_opYLabelLeftLine_textChanged(QString );
    void on_outputTab_currentChanged(int );
    void on_sampleSizeTab_currentChanged(int );
    void on_sfl0PCombo_currentIndexChanged(int );
    void on_sfl1PCombo_currentIndexChanged(int );
    void on_sfl1PDSpin_valueChanged();
    void on_sfl2PFunCombo_currentIndexChanged(int );
    void on_sfl2PLMIntDSpin_valueChanged();
    void on_sfl2PLMSlpDSpin_valueChanged();
    void on_sfl2PPt1XDSpin_valueChanged();
    void on_sfl2PPt1YDSpin_valueChanged();
    void on_sfl2PPt2XDSpin_valueChanged();
    void on_sfl2PPt2YDSpin_valueChanged();
    void on_sfl2PTab_currentChanged(int );
    void on_sfl3PLMDfDSpin_valueChanged();
    void on_sfl3PLMIntDSpin_valueChanged();
    void on_sfl3PLMSlpDSpin_valueChanged();
    void on_sfl3PPt1XDSpin_valueChanged();
    void on_sfl3PPt1YDSpin_valueChanged();
    void on_sfl3PPt2XDSpin_valueChanged();
    void on_sfl3PPt2YDSpin_valueChanged();
    void on_sfl3PPtsDfDSpin_valueChanged();
    void on_sfl3PTab_currentChanged(int );
    void on_sflLBSCombo_currentIndexChanged(int );
    void on_sflLBTCombo_currentIndexChanged(int );
    void on_sflParamToolBox_currentChanged(int );
    void on_sflPiecePtsSpin_valueChanged(int );
    void on_sflPieceTableX_cellChanged(int, int );
    void on_sflPieceTableY_cellChanged(int, int );
    void on_sflPieceUseInterimRadio_clicked(bool );
    void on_sflPieceUseInterimRadio_toggled(bool );
    void on_sflTestCombo_currentIndexChanged(int );
    void on_sfu0PCombo_currentIndexChanged(int );
    void on_sfu1PCombo_currentIndexChanged(int );
    void on_sfu1PDSpin_valueChanged();
    void on_sfu2PFunCombo_currentIndexChanged(int );
    void on_sfu2PLMIntDSpin_valueChanged();
    void on_sfu2PLMSlpDSpin_valueChanged();
    void on_sfu2PPt1XDSpin_valueChanged();
    void on_sfu2PPt1YDSpin_valueChanged();
    void on_sfu2PPt2XDSpin_valueChanged();
    void on_sfu2PPt2YDSpin_valueChanged();
    void on_sfu2PTab_currentChanged(int );
    void on_sfu3PLMDfDSpin_valueChanged();
    void on_sfu3PLMIntDSpin_valueChanged();
    void on_sfu3PLMSlpDSpin_valueChanged();
    void on_sfu3PPt1XDSpin_valueChanged();
    void on_sfu3PPt1YDSpin_valueChanged();
    void on_sfu3PPt2XDSpin_valueChanged();
    void on_sfu3PPt2YDSpin_valueChanged();
    void on_sfu3PPtsDfDSpin_valueChanged();
    void on_sfu3PTab_currentChanged(int );
    void on_sfuParamToolBox_currentChanged(int );
    void on_sfuPiecePtsSpin_valueChanged(int );
    void on_sfuPieceTableX_cellChanged(int, int );
    void on_sfuPieceTableY_cellChanged(int, int );
    void on_sfuPieceUseInterimRadio_clicked(bool );
    void on_sfuPieceUseInterimRadio_toggled(bool );
    void on_spendingFunctionTab_currentChanged(int );
    void on_ssBinControlDSpin_valueChanged();
    void on_ssBinDeltaDSpin_valueChanged();
    void on_ssBinExpDSpin_valueChanged();
    void on_ssBinFixedSpin_valueChanged(int );
    void on_ssBinRatioDSpin_valueChanged();
    void on_ssBinSupCombo_currentIndexChanged(int );
    void on_ssTEAccrualCombo_currentIndexChanged();
    void on_ssTEAccrualDSpin_valueChanged();
    void on_ssTECtrlDSpin_valueChanged();
    void on_ssTEDropoutDSpin_valueChanged();
    void on_ssTEExpDSpin_valueChanged();
    void on_ssTEFixedEventSpin_valueChanged(int );
    void on_ssTEFixedSpin_valueChanged(int );
    void on_ssTEFollowDSpin_valueChanged();
    void on_ssTEGammaDSpin_valueChanged();
    void on_ssTEHypCombo_currentIndexChanged(int );
    void on_ssTERatioDSpin_valueChanged();
    void on_ssTESwitchCombo_currentIndexChanged(int );
    void on_ssUserFixedSpin_valueChanged(int );
    void on_toolbarActionContextHelp_triggered();
    void on_toolbarActionDefaultDesign_triggered();
    void on_toolbarActionDeleteDesign_hovered();
    void on_toolbarActionDeleteDesign_triggered();
    void on_toolbarActionExportDesign_triggered();
    void on_toolbarActionLoadDesign_triggered();
    void on_toolbarActionNewDesign_hovered();
    void on_toolbarActionNewDesign_triggered();
    void on_toolbarActionRunDesign_triggered();
    void on_toolbarActionSaveDesign_triggered();
    void runDesign();
    void setCurrentFile(const QString &fileName);
    void setDefaultDesign();
    void setDeleteDesignVisibility();
    void setDeltaRange();
    void setPlotDefaults();
    void setPlotWidgetsEnable();
    void setPowerMinimum();
    void setSpendingPointsBounds(QDoubleSpinBox *dspin1, QDoubleSpinBox *dspin2);
    void setStatusTips();
    void setHelpTips();
    void setTimeToEventSuffixes();
    void setTimingTableEnable();
    void setTimingTableRows();
    void sortTableRows(QTableWidget *table, Qt::SortOrder order);
    void spendingFunctionPiecewiseTableNROWUpdate(QRadioButton *useInterimRadio, QSpinBox *nIntervalsSpin, QTableWidget *tableX, QTableWidget *tableY);
    void updateDesignMapQComboBox(QComboBox *combo);
    void updateDesignMapQDoubleSpinBox(QDoubleSpinBox *dspin);
    void updateDesignMapQLineEdit(QLineEdit *line);
    void updateDesignMapQRadioButton(QRadioButton *button);
    void updateDesignMapQSpinBox(QSpinBox *spin);
    void updateDesignMapQTabWidget(QTabWidget *tab);
    void updateDesignMapQTableWidget(QTableWidget *table);
    void updateDesignMapQToolBox(QToolBox *page);
    void updateTimeToEventValues();
    void updateOutputPlotMap(gsDesign::MapAction action);
    void update_opWidgetMapEntry(QString key, QString value);
    void setHazardRatio();
    void blockPlotSignals(bool block);

private:
    Ui::gsDesign *ui;

    // GUI version
    QString gsDesignExplorerVersion;

    // number of new designs (ensures unique name for new designs)
    int newDesigns;

    // last mode stack index
    int lastModeStack;
    bool plotSwitch;
    bool designRunOnce;

    // event rate double precisions containers
    double controlER;
    double experimentalER;
    double dropoutER;

    // QMaps for output plot
    QMap<QString, QString> opBoundariesMap;
    QMap<QString, QString> opPowerMap;
    QMap<QString, QString> opTreatmentMap;
    QMap<QString, QString> opConditionalPowerMap;
    QMap<QString, QString> opSpendingMap;
    QMap<QString, QString> opSampleSizeMap;
    QMap<QString, QString> opBValuesMap;

    // QList of QMaps comprising design list
    QList<QMap<QString, QString> > designList;
    QMap<QString, QString> defaultDesign;

    // File I/O
    QString currentDesignFile;
    QString plotFilePath;
    QDir currentWorkingDirectory;
};

#endif // GSDESIGN_H
