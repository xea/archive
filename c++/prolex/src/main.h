#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif
#include <wx/choicdlg.h>
#include <wx/colour.h>
#include <wx/dialog.h>
#include <wx/gdicmn.h>
#include <wx/image.h>
#include <wx/listbox.h>
#include <wx/listctrl.h>
#include <wx/printdlg.h>
#include <wx/splash.h>
#include <wx/textctrl.h>
#include <wx/wx.h>
#include <sqlite.h>

#define MAINVERSION 0
#define SUBVERSION  8
#define BUILD       562

enum
{
	browser,
	Program_Quit, 
	Window_Tile,
	Window_Cascade,
	Window_Next,
	Window_Prev,
	Database_Open,
	Database_Close,
	Track_Changes,
	Filter_Add,
	Filter_Invert,
	Titles_Export,
	Titles_Preview,
	Titles_Search,
	Text_HTML_Export,
	Text_XML_Export,
	Text_References, 
	Text_Comments,
	Print_Print,
	Print_Page, 
	Print_Settings, 
	Search_Rights,
	Settings_Languages, 
	Settings_Fonts,
	Splash_OK,
	DialogOk,
	DialogCancel,
	Event,
	listtoc,
	dbtoc,
	MDI_QUIT = 100,
   MDI_NEW_WINDOW,
   MDI_REFRESH,
   MDI_CHANGE_TITLE,
   MDI_CHANGE_POSITION,
   MDI_CHANGE_SIZE,
   MDI_CHILD_QUIT,
   MDI_ABOUT,
	dbopen,
	toc,
	Program_About = wxID_ABOUT
};
       