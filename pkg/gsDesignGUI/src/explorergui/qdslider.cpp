#include "qdslider.h"

QDSlider::QDSlider():QSlider() {}
QDSlider::QDSlider( QWidget *parent = 0 ):QSlider( parent ) {}
QDSlider::QDSlider( Qt::Orientation orientation , QWidget *parent = 0 ):QSlider( orientation , parent ) {}

void QDSlider::setValue( double value )
{
  int ivalue = value * 10;
  emit QSlider::setValue( ivalue );
}

void QDSlider::valueDChanged( int value )
{
  double dvalue = (double)value / 10.0;
  emit valueChanged( dvalue );
}
