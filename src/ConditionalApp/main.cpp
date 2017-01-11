#include <opencv2/highgui/highgui.hpp>
#include <iostream>

#ifdef HAS_QT
#include <QMainWindow>
#include <QApplication>
#endif

#ifdef HAS_PIL
#include <base/Svar/Svar.h>
#endif

using namespace std;

int main(int argc,char** argv)
{
  string Libs;
  cv::Mat img(255,255,CV_8UC3);
  cv::imshow("img",img);
  cv::waitKey(0);
  Libs+=("OpenCV");
#ifdef HAS_PIL
  svar.ParseMain(argc,argv);
  Libs+=(" PIL");
#endif

#ifdef HAS_QT
  Libs+=(" Qt");
  QApplication app(argc,argv);
  QMainWindow window(NULL);
  window.show();
#endif

  cout<<"Compiled with "<<Libs;
#ifdef HAS_QT
  return app.exec();
#else
  return 0;
#endif
}
