#include "wx/wxprec.h"

#ifdef __BORLANDC__
    #pragma hdrstop
#endif
#ifndef WX_PRECOMP
    #include "wx/wx.h"
#endif

#include <sqlite.h>
#include <wx/image.h>
#include <wx/listctrl.h>

enum
{
    Program_Quit = 1,
    Program_About = wxID_ABOUT,
    DBOpen,
    command
};
       