#include "main.h"
class Master : public wxApp
{
public:
    virtual bool OnInit();
};

class wSQLiteDB
{
	public:
		int Open(const char* dbase);
		void Close(void);
		char *err;
		sqlite *db;
	private:
};

class wSQLiteQuery:public wSQLiteDB
{
	public:
		void GetTable(const char* sql);
		void FreeTable(void);
		int numcols; 
		int numrows; 
		char **result; 
		int j; 
		wxString buf; 
	private:
};

class wFrame : public wxFrame
{
public:
    wFrame(const wxString& title, const wxPoint& pos, const wxSize& size, long style = wxDEFAULT_FRAME_STYLE);
    void OnQuit(wxCommandEvent& event);
    void OnAbout(wxCommandEvent& event);
    void DataOpen(wxCommandEvent& event);
    void OnEnter(wxCommandEvent & event);
    wxFileDialog * filedlg;
    wxBoxSizer* sizer_10;
    wxMenuBar* menubar;
    wxStatusBar* statusbar;
    wxListCtrl* list;
    wxTextCtrl* text;
    bool isOpened;
    wSQLiteQuery * db;
    wxString database;
private:
    DECLARE_EVENT_TABLE()
};

BEGIN_EVENT_TABLE(wFrame, wxFrame)
	 EVT_MENU(DBOpen, wFrame::DataOpen)
  	 EVT_TEXT_ENTER(command, wFrame::OnEnter)
    EVT_MENU(Program_Quit,  wFrame::OnQuit)
    EVT_MENU(Program_About, wFrame::OnAbout)
END_EVENT_TABLE()

IMPLEMENT_APP(Master)

bool Master::OnInit()
{
    wFrame *frame = new wFrame(_T("SQLiteMaster"), wxPoint(50, 50), wxSize(640, 480));
    frame->Show(TRUE);
    return TRUE;
}


wFrame::wFrame(const wxString& title, const wxPoint& pos, const wxSize& size, long style):wxFrame(NULL, -1, title, pos, size, style)
{
#if wxUSE_MENUS
	 db = new wSQLiteQuery;
    wxMenu *menuFile = new wxMenu;
    wxMenu *helpMenu = new wxMenu;
    helpMenu->Append(Program_About, _T("&About...\tF1"), _T("Show about dialog"));
    menuFile->Append(DBOpen, _T("Adatbázis &megnyitása"), _T("Megnyit egy tetszõleges adatbázist"));
    menuFile->Append(Program_Quit, _T("E&xit\tAlt-X"), _T("Quit this program"));
    wxMenuBar *menuBar = new wxMenuBar();
    menuBar->Append(menuFile, _T("&File"));
    menuBar->Append(helpMenu, _T("&Help"));
    SetMenuBar(menuBar);
#endif // wxUSE_MENUS

#if wxUSE_STATUSBAR
    CreateStatusBar(2);
    SetStatusText(_T("Welcome to wxWindows!"));
#endif // wxUSE_STATUSBAR
    list = new wxListCtrl(this, -1, wxDefaultPosition, wxDefaultSize, wxLC_REPORT|wxSUNKEN_BORDER);
    text = new wxTextCtrl(this, command, wxT(""), wxPoint(-1, -1), wxSize(-1, -1), wxTE_RICH2 | wxTE_PROCESS_ENTER);
    SetSize(wxSize(647, 513));
    wxBoxSizer* sizer_10 = new wxBoxSizer(wxVERTICAL);
    sizer_10->Add(list, 1, wxEXPAND, 0);
    sizer_10->Add(text, 0, wxEXPAND, 0);
    SetAutoLayout(true);
    SetSizer(sizer_10);
    Layout();
}

void wFrame::OnQuit(wxCommandEvent& WXUNUSED(event))
{
    // TRUE is to force the frame to close
    Close(TRUE);
}

void wFrame::OnAbout(wxCommandEvent& WXUNUSED(event))
{
    wxString msg;
    msg.Printf( _T("This is the About dialog of the Program sample.\n")
                _T("Welcome to %s"), wxVERSION_STRING);

    wxMessageBox(msg, _T("About Program"), wxOK | wxICON_INFORMATION, this);
}

void wFrame::DataOpen(wxCommandEvent & event)
{
	filedlg = new wxFileDialog(this, _T("Válasszon egy filet"), _T("."), _T(""), _T("*.*"), wxOPEN);
	filedlg->ShowModal();
	database = filedlg->GetFilename();
	delete filedlg;
}

void wFrame::OnEnter(wxCommandEvent & event)
{
	int i;
	int j;
	db->Open(database.c_str());

	wxString res;
	wxString a;
	res = text->GetValue();
	a = wxString(res.c_str(), wxConvUTF8);
	db->GetTable(a.c_str());
	wxString k;
	k.Printf(_T("%s"), db->err);
	if(!k.IsEmpty())
	{
		wxMessageBox(k, _T("Title"),wxOK);
	}
	list->ClearAll();
	if (db->numcols > 0)
	{

	for (i = 0; i < db->numcols; i++)
	{
		list->InsertColumn(i, db->result[i], wxLIST_FORMAT_LEFT);
	}
	for (i = 0; i <= db->numrows; i++)
	{
		list->InsertItem(i - 1, db->result[(i * db->numcols)]);
		for (j = 1; j < db->numcols; j++)
		{
			list->SetItem(i - 1, j, db->result[(i * db->numcols) + j]);
		}
	}
	db->FreeTable();
	}
	db->Close();
}

int wSQLiteDB::Open(const char * dbase)
{
	this->db = sqlite_open(dbase, 0, &(this->err));
	return 1;
}

void wSQLiteDB::Close(void)
{
	sqlite_close(this->db);
}

// #########################################################################################################################
// #########################################################################################################################

void wSQLiteQuery::GetTable(const char* sql)
{
	wxString converter;
	converter = wxString(sql, wxConvUTF8);
	sqlite_get_table(this->db, converter.c_str(), &(this->result), &(this->numrows), &(this->numcols), &(this->err));
}

void wSQLiteQuery::FreeTable(void)
{
	sqlite_free_table(this->result); 
}
