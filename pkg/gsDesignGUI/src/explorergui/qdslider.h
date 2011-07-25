// Copyright (C) 2009 Merck Research Laboratories and REvolution Computing, Inc.
//
//  This file is part of gsDesignExplorer.
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

#ifndef QDSLIDER_H
#define QDSLIDER_H

#include <QSlider>

class QDSlider : public QSlider
{
  Q_OBJECT
public:
  explicit QDSlider();
  explicit QDSlider( QWidget * );
  explicit QDSlider( Qt::Orientation , QWidget * );
signals:
  void valueChanged( double );
  void sliderMoved( double );
private slots:
  void setValue( double );
  void valueDChanged( int );
};

#endif
