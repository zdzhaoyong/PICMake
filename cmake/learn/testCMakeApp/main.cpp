#include <QtGui/QMainWindow>
#include <QApplication>


int main(int argc,char** argv)
{
	QApplication app(argc,argv);
	QMainWindow window(NULL);
	window.show();
        return app.exec();
}
