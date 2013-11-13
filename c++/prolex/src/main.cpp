#include "main.h"
#include "lang_hu.h"

class wMenu:public wxMenu
{
	public:
		void AddMenu(bool enable, int id, const wxString& title, const wxString& helptext);
};


class Roman
{
	public:
		int roti(wxString roman);
		wxString itor(int integer);
	private:
		wxString output;
		wxString tmp;
		unsigned	int i;
};

class wList:public wxListCtrl
{
	public:
		wList(wxWindow* parent, wxWindowID id, wxPoint pos, wxSize size);
		void OnSelected(wxListEvent& event);
		void OnActivated(wxListEvent& event);
		void OnTocActivated(wxListEvent& event);
		wxString db;
		long id;
		int Selected;
	private:
		DECLARE_EVENT_TABLE()
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

class wDlgDBOpen:public wxDialog
{
	public:
		wDlgDBOpen(wxWindow * parent, wxWindowID id, const wxString & title, const wxPoint & pos, const wxSize & size);
		void OnOk(wxCommandEvent & event);
		void OnCancel(wxCommandEvent & event);
		wxString db;
	private:
		DECLARE_EVENT_TABLE()
};

class wChild:public wxMDIChildFrame
{
    public:
	    wChild(wxMDIParentFrame * parent, const wxString & title, const wxPoint & pos, const wxSize & size, const long style);
   	 ~wChild();
    	void OnQuit(wxCommandEvent & event);
     	wxList my_children;
    private:
	    DECLARE_EVENT_TABLE()
};

class wBrowser:public wChild
{
	public:
		wBrowser(wxMDIParentFrame * parent, const wxString & title, const wxPoint & pos, const wxSize & size, const long style);
	private:
		DECLARE_EVENT_TABLE()
};
	

class wParent:public wxMDIParentFrame
{
 public:
	wParent(wxWindow * parent, const wxWindowID id, const wxString & title, const wxPoint & pos, const wxSize & size, const long style = wxDEFAULT_FRAME_STYLE | wxMAXIMIZE);
 	void SetDBOLayout(void);
	void SetMenu(void);
 	void DBOpen(wxCommandEvent & event);
 	void DBClose(wxCommandEvent & event);
 	void CloseBrowser(wxCommandEvent & event);
 	void OnQuit(wxCommandEvent & event);
 	void OnAbout(wxCommandEvent & event);
 	void OnActivated(wxListEvent& event);
 	void Print(wxCommandEvent & event);
	void PrintPage(wxCommandEvent & event);
 	void WindowTile(wxCommandEvent & event);
	void WindowCascade(wxCommandEvent & event);
	void WindowNext(wxCommandEvent & event); 
	void WindowPrev(wxCommandEvent & event);
 	wChild * table;
 	wBrowser * browser;
 	wSQLiteQuery * open;
 	wList * toc;
 	wMenu * menuFile;
  	wMenu * menuWindow;
	wMenu * menuSearch;
	wMenu * menuTimeM;
	wMenu * menuTitles;
	wMenu * menuText;
	wMenu * menuPrint;
	wMenu * menuSettings;
	wMenu * menuHelp;
 	wxString db;
 	wxString selected;
 	int HasChild;
	int isBrowsing;
	long tocId;
	long id;
 private:
   DECLARE_EVENT_TABLE()
};

class ProLex:public wxApp
{
 public:
	virtual bool OnInit();
	void Splash(bool);
 	wParent * root;
};

// #########################################################################################################################
// #########################################################################################################################

BEGIN_EVENT_TABLE(wParent, wxMDIParentFrame)
	EVT_MENU(Database_Open, wParent::DBOpen)
	EVT_MENU(Database_Close, wParent::DBClose)
	EVT_MENU(Program_Quit, wParent::OnQuit)
	EVT_MENU(Program_About, wParent::OnAbout)
	EVT_MENU(Print_Print, wParent::Print)
	EVT_MENU(Print_Page, wParent::PrintPage)
	EVT_MENU(Window_Tile, wParent::WindowTile)
	EVT_MENU(Window_Cascade, wParent::WindowCascade)
	EVT_MENU(Window_Next, wParent::WindowNext)
	EVT_MENU(Window_Prev, wParent::WindowPrev)
	EVT_LIST_ITEM_ACTIVATED(dbtoc, wParent::OnActivated)
END_EVENT_TABLE()

BEGIN_EVENT_TABLE(wChild, wxMDIChildFrame) 
	EVT_CLOSE(wChild::OnQuit) 
END_EVENT_TABLE()

BEGIN_EVENT_TABLE(wBrowser, wChild)
	EVT_CLOSE(wParent::CloseBrowser)
END_EVENT_TABLE()

BEGIN_EVENT_TABLE(wDlgDBOpen, wxDialog)
	EVT_BUTTON(DialogOk, wDlgDBOpen::OnOk)
	EVT_BUTTON(DialogCancel, wDlgDBOpen::OnCancel)
END_EVENT_TABLE()

BEGIN_EVENT_TABLE(wList, wxListCtrl)
	EVT_LIST_ITEM_SELECTED(dbopen, wList::OnSelected)
	EVT_LIST_ITEM_ACTIVATED(dbopen, wList::OnActivated)
	EVT_LIST_ITEM_SELECTED(dbtoc, wList::OnTocActivated)
END_EVENT_TABLE()

// #########################################################################################################################
// #########################################################################################################################

IMPLEMENT_APP(ProLex)

// #########################################################################################################################
// #########################################################################################################################


bool ProLex::OnInit()
{
	Splash(false);
	root = new wParent((wxFrame *) NULL, -1, __I_TITLE, wxPoint(-1, -1), wxSize(500, 400), wxDEFAULT_FRAME_STYLE | wxHSCROLL | wxVSCROLL | wxMAXIMIZE);
	return TRUE;
}

void ProLex::Splash(bool show)
{
	if (show)
	{
		wxBitmap bitmap; 
		int timeout; 
		if (bitmap.LoadFile("logo.bmp", wxBITMAP_TYPE_BMP))
		{	
			wxSplashScreen * splash = new wxSplashScreen(bitmap, wxSPLASH_CENTRE_ON_SCREEN | wxSPLASH_TIMEOUT, 2000, NULL, -1, wxDefaultPosition, wxDefaultSize, wxSIMPLE_BORDER | wxSTAY_ON_TOP); 
         timeout = splash->GetTimeout();
		}
		wxYield();
	}
}

// #########################################################################################################################
// #########################################################################################################################

wParent::wParent(wxWindow * parent, const wxWindowID id, const wxString & title, const wxPoint & pos, const wxSize & size, const long style):wxMDIParentFrame(parent, id, title, pos, size, style | wxNO_FULL_REPAINT_ON_RESIZE | wxFRAME_NO_WINDOW_MENU)
{
	SetMenu();
#if wxUSE_STATUSBAR
	CreateStatusBar(1); 
	SetStatusText(__I_STATUS);
#endif
	this->Show(TRUE); 
	this->Maximize(TRUE); 	
	this->db.Empty();
	this->HasChild = 0;
	this->isBrowsing = 0;
}

void wParent::SetMenu(void)
{
#if wxUSE_MENUS
	menuFile = new wMenu;
	menuWindow = new wMenu;
	menuSearch = new wMenu;
	menuTimeM = new wMenu;
	menuTitles = new wMenu;
	menuText = new wMenu;
	menuPrint = new wMenu;
	menuSettings = new wMenu;
	menuHelp = new wMenu;
	wxMenuBar * menuBar = new wxMenuBar();
	
	menuBar->Append(menuFile, __I_MFILE);
	menuBar->Append(menuTimeM, __I_MTIME);
	menuBar->Append(menuTitles, __I_MTITLES);
	menuBar->Append(menuText, _T("S&zöveg")); 
	menuBar->Append(menuPrint, _T("&Nyomtatás")); 
	menuBar->Append(menuSearch, _T("&Keresés")); 
	menuBar->Append(menuSettings, _T("&Beállítások")); 
	menuBar->Append(menuWindow, _T("&Ablak")); 
	menuBar->Append(menuHelp, _T("&Súgó")); 
	
	menuFile->AddMenu(TRUE, Database_Open, _T("&Adatbázis megnyitása"), _T("Megnyit egy új adatbázist a lemezen"));
	menuFile->AddMenu(FALSE, Database_Close, _T("Adatbázis &bezárása"), _T("A megnyitott adatbázis bezárása"));
	menuFile->AppendSeparator();
	menuFile->AddMenu(TRUE, Program_Quit, _T("&Kilépés\tAlt-X"), _T("Kilépés a programból"));
	menuTimeM->AddMenu(FALSE, Track_Changes, _T("&Változások követése"), _T("A jogszabályokban bekövetkezett változások megjelenítése"));
	//menuTimeM->Enable(Track_Changes, FALSE);
	menuTitles->AddMenu(FALSE, Filter_Add, _T("&Címmutató szûkítése"), _T("A címmutató szûkítése megadott feltételek alapján"));
	menuTitles->AddMenu(FALSE, Filter_Invert, _T("&Szûrõ invertálása"), _T("A szûrõ feltételének megfordítása"));
	menuTitles->AddMenu(FALSE, Titles_Export, _T("Címjegyzék &exportálása"), _T("A Címjegyzék tartalmának kimentése lemezre"));
	menuTitles->AddMenu(FALSE, Titles_Preview, _T("Elõ&nézet"), _T("Gyors elõnézeti kép megnyitása"));
	menuTitles->AddMenu(FALSE, Titles_Search, _T("&Joganyag keresés"), _T("Keresés a joganyagban"));
	menuText->AddMenu(FALSE, Text_HTML_Export, _T("Exportálás &HTML-be"), _T("Szöveganyag exportálása HTML formátumba"));
	menuText->AddMenu(FALSE, Text_XML_Export, _T("Exportálás &XML-be"), _T("Szöveganyag exportálása XML formátumba"));
	menuText->AddMenu(FALSE, Text_References, _T("&Kapcsolódó anyagok"), _T("Kapcsolódó anyagok megjelenítése"));
	menuText->AddMenu(FALSE, Text_Comments, _T("&Megjegyzések"), _T("A szöveghez kapcsolódó megjegyzések megjelenítése")); 
	menuPrint->AddMenu(FALSE, Print_Print, _T("&Nyomtatás"), _T("A kiválasztott anyag kinyomtatása"));
	menuPrint->AddMenu(TRUE, Print_Page, _T("&Laptulajdonságok"), _T("A nyomtatáshoz használt lap beállítása"));
	menuPrint->AddMenu(TRUE, Print_Settings, _T("Nyomtatási &tulajdonságok"), _T("A nyomtatás részletes beállítása"));
	menuSearch->AddMenu(FALSE, Search_Rights, _T("Joganyag &keresése"), _T("Joganyag kikeresése az adatbázisból"));
	menuSettings->AddMenu(FALSE, Settings_Languages, _T("&Nyelv beállítása"), _T("A programban szereplõ szövegek nyelvének meghatározása"));
	menuSettings->AddMenu(FALSE, Settings_Fonts, _T("&Betûtípusok beállítása"), _T("A szövegek betûtípusainak beállítása"));
	menuWindow->AddMenu(TRUE, Window_Tile, _T("&Mozaikszerû rendezés"), _T("A megjelenitett ablakok mozaikos megjelenítése"));
	menuWindow->AddMenu(TRUE, Window_Cascade, _T("&Lépcsõzetes rendezés"), _T("A megjelenített ablakok lépcsõzetes megjelenítése"));
	menuWindow->AddMenu(TRUE, Window_Next, _T("&Következõ ablak"), _T("A sorban következõ ablak mutatása"));
	menuWindow->AddMenu(TRUE, Window_Prev, _T("&Elõzõ ablak"), _T("A sorban elõzõ ablak mutatása"));
	menuHelp->AddMenu(TRUE, Program_About, _T("A &Programról\tAlt-P"), _T("A programról"));
	
	SetMenuBar(menuBar);
#endif
}

void wParent::DBOpen(wxCommandEvent & WXUNUSED(event))
{
	int i;
	wDlgDBOpen * dlg = new wDlgDBOpen(this, -1, __I_DBSELECT, wxPoint(100,100), wxSize(550,300));

	wList * lst = new wList(dlg, dbopen, wxDefaultPosition, wxSize(530, 50));
	lst->InsertColumn(1, __I_DB, wxLIST_FORMAT_LEFT, 270);
	lst->InsertColumn(2, __I_DBCLOSEDATE, wxLIST_FORMAT_LEFT, 120);
	lst->InsertColumn(3, __I_DBFILE, wxLIST_FORMAT_LEFT, 150);
	wxButton * ButtonOk = new wxButton(dlg, DialogOk, __I_OK);
	wxButton * ButtonCancel = new wxButton(dlg, DialogCancel, __I_CANCEL);
	wxBoxSizer * sizer_6 = new wxBoxSizer(wxVERTICAL);
	wxBoxSizer * sizer_7 = new wxBoxSizer(wxHORIZONTAL); 
	ButtonOk->SetDefault();
	sizer_6->Add(lst, 1, wxEXPAND, 0); 
	sizer_7->Add(ButtonOk, 0, 0, 0); 
	sizer_7->Add(20, 20, 0, 0, 0); 
	sizer_7->Add(ButtonCancel, 0, 0, 0); 
	sizer_6->Add(sizer_7, 0, wxALIGN_CENTER_HORIZONTAL, 0); 
	dlg->SetAutoLayout(true); 
	dlg->SetSizer(sizer_6); 
	dlg->Layout();
	
	open = new wSQLiteQuery;
	open->Open("wxData.sqd");
	open->GetTable("select * from databases;");
	for (i = 1; i <= open->numrows; i++)
	{
		lst->InsertItem(i - 1, open->result[(i * open->numcols) + 2]); 
		lst->SetItem(i - 1, 1, open->result[(i * open->numcols) + 3]);
		lst->SetItem(i - 1, 2, open->result[(i * open->numcols) + 1]);
	}
	
	if(dlg->ShowModal() == wxID_OK)
	{
		if (lst->Selected == 1)
		{
			this->db.Printf(_T("%s"),open->result[((lst->id + 1) * open->numcols) + 1]);
		}
		if (!db.IsEmpty())
		{
			wxString a;
			int j;
			if (this->HasChild == 1)
			{
				a.Printf(_T("Closing database.."));
				this->SetStatusText(a);
				delete toc;
				delete table;
			}	
			a.Printf(_T("Opening database: %s"), this->db.c_str());
			this->SetStatusText(a);
			this->HasChild = 1;
			table = new wChild(this, __I_TOC, wxPoint(-1,-1), wxSize(-1, -1), wxDEFAULT_FRAME_STYLE | wxMAXIMIZE);
			toc = new wList(table, dbtoc, wxDefaultPosition, wxSize(-1, -1));
			wxBoxSizer * tocsizer = new wxBoxSizer(wxVERTICAL);
			toc->InsertColumn(1, __I_TOCYEAR, wxLIST_FORMAT_LEFT, 42);
			toc->InsertColumn(2, __I_TOCMONTH, wxLIST_FORMAT_LEFT, 30);
			toc->InsertColumn(3, __I_TOCDAY, wxLIST_FORMAT_LEFT, 32);
			toc->InsertColumn(4, __I_TOCIDX, wxLIST_FORMAT_LEFT, 42);
			toc->InsertColumn(5, _T("No."), wxLIST_FORMAT_LEFT, 42);
			toc->InsertColumn(6, _T("Jogterület"), wxLIST_FORMAT_LEFT, 100);
			toc->InsertColumn(7, _T("Kategória"), wxLIST_FORMAT_LEFT, 100);
			toc->InsertColumn(8, __I_TOCTITLE, wxLIST_FORMAT_LEFT, 400);
			tocsizer->Add(toc, 1, wxEXPAND, 0);
			
			wSQLiteQuery * tocquery = new wSQLiteQuery;
			tocquery->Open(this->db.c_str());
			tocquery->GetTable("select toc.idx, toc.year, toc.month, toc.day, toc.no, types.long, areas.area, toc.title from types, areas, toc where types.type = toc.type and areas.idx = toc.area order by toc.idx;");
			for (j = 1; j <= tocquery->numrows; j++)
			{
				toc->InsertItem(j - 1, tocquery->result[(j * tocquery->numcols) + 1]); 
				toc->SetItem(j - 1, 1, tocquery->result[(j * tocquery->numcols) + 2]);
				toc->SetItem(j - 1, 2, tocquery->result[(j * tocquery->numcols) + 3]);
				toc->SetItem(j - 1, 3, tocquery->result[(j * tocquery->numcols)]);
				toc->SetItem(j - 1, 4, tocquery->result[(j * tocquery->numcols) + 4]);
				toc->SetItem(j - 1, 5, tocquery->result[(j * tocquery->numcols) + 6]);
				toc->SetItem(j - 1, 6, tocquery->result[(j * tocquery->numcols) + 5]);
				toc->SetItem(j - 1, 7, tocquery->result[(j * tocquery->numcols) + 7]);
			}
			tocquery->FreeTable();
			tocquery->Close();
			a.Printf(_T("Az adatbazisban %d bejegyzes talalhato"), tocquery->numrows);
			this->SetStatusText(a);
			this->menuFile->Enable(Database_Close, TRUE);
			delete tocquery;
		}
		
	}
	open->FreeTable();
	open->Close();
	delete dlg;
}

void wParent::OnActivated(wxListEvent& event)
{
   wxListItem info;   
   info.m_itemId = event.m_itemIndex;
   info.m_col = 3;
   info.m_mask = wxLIST_MASK_TEXT;
   this->toc->GetItem(info);
   this->selected.Printf(_T("%s"),info.m_text.c_str());
 	this->id = event.GetIndex();
	if (this->isBrowsing == 1)
	{
		//delete browser;
	}
	this->isBrowsing = 1;	

	browser = new wBrowser(this, __I_BROWSER, wxPoint(-1,-1), wxSize(-1, -1), wxDEFAULT_FRAME_STYLE | wxMAXIMIZE);

	wxTextCtrl * text = new wxTextCtrl(browser, -1, _T(""), wxPoint(-1, -1), wxSize(600, -1), wxTE_READONLY | wxTE_RICH2 | wxTE_MULTILINE);
	text->SetBackgroundColour(wxColour(255,255,234));
	wSQLiteQuery * cont = new wSQLiteQuery;
	wxString sqlcommand;
	int i, j;
	sqlcommand.Printf(_T("select * from data where parent=\"%s\" order by idx;"), this->selected.c_str());
   
   text->SetDefaultStyle(wxTextAttr(wxNullColour, wxNullColour, wxFont(12, wxDEFAULT, wxNORMAL, wxBOLD)));
	
	info.m_col = 0;
   info.m_mask = wxLIST_MASK_TEXT;
   this->toc->GetItem(info);
   text->AppendText(info.m_text.c_str());
   text->AppendText(". évi ");
   
 	info.m_col = 4;
   info.m_mask = wxLIST_MASK_TEXT;
   this->toc->GetItem(info);
   wxString r;
   Roman a;
   r = a.itor(atoi(info.m_text.c_str()));
   //text->AppendText(info.m_text.c_str());
   text->AppendText(r.c_str());
   text->AppendText(". ");
   info.m_col = 6;
   this->toc->GetItem(info);
   text->AppendText(info.m_text.c_str());
   text->AppendText("\n\n");
   info.m_col = 7;
   this->toc->GetItem(info);
   text->AppendText(info.m_text.c_str());
   text->AppendText("\n\n");
      
   text->SetDefaultStyle(wxTextAttr(wxNullColour));
   
 	cont->Open(this->db.c_str());
	cont->GetTable(sqlcommand.c_str());
	text->SetDefaultStyle(wxTextAttr(wxNullColour, wxNullColour, wxFont(10, wxDEFAULT, wxNORMAL, wxNORMAL)));
	for (i = 1; i <= cont->numrows; i++)
	{
		for (j = 0; j < atoi(cont->result[(i * cont->numcols) + 3]); j++)
		{
			text->AppendText("\t");
		}
		for (j = 0; j < atoi(cont->result[(i * cont->numcols) + 4]); j++)
		{
			text->AppendText(" ");
		}
		text->SetDefaultStyle(wxTextAttr(wxNullColour, wxNullColour, wxFont(10, wxDEFAULT, wxNORMAL, wxBOLD)));
		text->AppendText(cont->result[(i * cont->numcols) + 6]);
		text->SetDefaultStyle(wxTextAttr(wxNullColour, wxNullColour, wxFont(10, wxDEFAULT, wxNORMAL, wxNORMAL)));		
		text->AppendText(" ");
		text->AppendText(cont->result[(i * cont->numcols) + 7]);
		text->AppendText("\n");
	}	
	cont->FreeTable();
	cont->Close();
	text->SetDefaultStyle(wxTextAttr(wxNullColour));
 	/*text->SetDefaultStyle(wxTextAttr(*wxRED));
   text->AppendText("Red text\n");
   text->SetDefaultStyle(wxTextAttr(wxNullColour, *wxLIGHT_GREY));
   text->AppendText("Red on grey text\n");
   text->SetDefaultStyle(wxTextAttr(*wxBLUE));
   text->AppendText("Blue on grey text\n");	
   text->WriteText(_T("\nLol\n"));*/
}

void wParent::DBClose(wxCommandEvent & event)
{
	this->HasChild = 0;
	this->menuFile->Enable(Database_Close, FALSE);
	//toc->Destroy();
	//table->Destroy();
//	browser->Destroy();
	delete toc;
	delete table;
	if (this->isBrowsing == 1) 
 	{ 
  	//	delete browser;
  		this->isBrowsing = 0;
	}
}

void wParent::CloseBrowser(wxCommandEvent & event)
{
	this->isBrowsing = 0;
	delete browser;
}

void wParent::Print(wxCommandEvent & event)
{
	wxPrintDialog * printdlg = new wxPrintDialog(this); 
	printdlg->ShowModal();
}

void wParent::PrintPage(wxCommandEvent & event)
{
	wxPageSetupDialog * pagestp = new wxPageSetupDialog(this); 
	pagestp->ShowModal();
}

void wParent::WindowTile(wxCommandEvent & event)
{
	this->Tile();
}

void wParent::WindowCascade(wxCommandEvent & event)
{
	this->Cascade();
}

void wParent::WindowNext(wxCommandEvent & event)
{
	this->ActivateNext();
}

void wParent::WindowPrev(wxCommandEvent & event)
{
	this->ActivatePrevious();
}

void wParent::OnAbout(wxCommandEvent & WXUNUSED(event))
{
	wxString AboutText; 
	AboutText.Printf(__I_ABOUT, MAINVERSION, SUBVERSION, BUILD); 
	wxMessageBox(AboutText, __I_ABOUTTITLE, wxOK | wxICON_INFORMATION, this);
}

void wParent::OnQuit(wxCommandEvent & WXUNUSED(event))
{
	this->Destroy();
}


// #########################################################################################################################
// #########################################################################################################################

wBrowser::wBrowser(wxMDIParentFrame * parent, const wxString & title, const wxPoint & pos, const wxSize & size, const long style):wChild(parent, title, pos, size, style)
{

}

// #########################################################################################################################
// #########################################################################################################################


wChild::wChild(wxMDIParentFrame * parent, const wxString & title, const wxPoint & pos, const wxSize & size, const long style):wxMDIChildFrame(parent, -1, title, pos, size, style | wxNO_FULL_REPAINT_ON_RESIZE)
{
	my_children.Append(this);
	SetSizeHints(100, 100);
}

wChild::~wChild()
{
	my_children.DeleteObject(this);
}

void wChild::OnQuit(wxCommandEvent & WXUNUSED(event))
{
	my_children.DeleteObject(this); 
	this->Destroy();
}
// #########################################################################################################################
// #########################################################################################################################

void wMenu::AddMenu(bool enable, int id, const wxString& title, const wxString& helptext)
{
	this->Append(id, title, helptext);
	this->Enable(id, enable);
}

// #########################################################################################################################
// #########################################################################################################################

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

// #########################################################################################################################
// #########################################################################################################################

wDlgDBOpen::wDlgDBOpen(wxWindow * parent, wxWindowID id, const wxString & title, const wxPoint & pos, const wxSize & size):wxDialog(parent, id, title, pos, size)
{
	
}

void wDlgDBOpen::OnOk(wxCommandEvent& WXUNUSED(event))
{
	
	this->EndModal(wxID_OK);
	this->Destroy();
}

void wDlgDBOpen::OnCancel(wxCommandEvent& WXUNUSED(event))
{
	this->EndModal(wxID_CANCEL);
	this->Destroy();
}

// #########################################################################################################################
// #########################################################################################################################

wList::wList(wxWindow* parent, wxWindowID id, wxPoint pos, wxSize size):wxListCtrl(parent, id, pos, size, wxLC_REPORT | wxSUNKEN_BORDER)
{
	this->SetBackgroundColour(wxColour(255,255,234));
	this->Selected = 0;
	//this->tocId = -1;
}

void wList::OnSelected(wxListEvent& event)
{
	this->id = event.GetIndex();	
	this->Selected = 1;
}

void wList::OnActivated(wxListEvent& event)
{
	this->Selected = 1;
	this->id = event.GetIndex();	
}

void wList::OnTocActivated(wxListEvent& event)
{
//	this->tocId = event.GetIndex();
}

// #########################################################################################################################
// #########################################################################################################################

int Roman::roti(wxString roman)
{
	return 1;
}

wxString Roman::itor(int integer)
{
	tmp.Printf(_T("%d"), integer);
	output.Empty();
	for (i = 0; i < tmp.Length(); i++)
	{
		if(tmp.Length() - i == 1)
		{
			switch(tmp.GetChar(i))
			{
				case 49:
					output.Append("I");
					break;
				case 50:
					output.Append("II");
					break;
				case 51:
					output.Append("III");
					break;
				case 52:
					output.Append("IV");
					break;
				case 53:
					output.Append("V");
					break;
				case 54:
					output.Append("VI");
					break;
				case 55:
					output.Append("VII");
					break;
				case 56:
					output.Append("VIII");
					break;
				case 57:
					output.Append("IX");
					break;
			}
		}
		else if(tmp.Length() - i == 2)
		{
			switch(tmp.GetChar(i))
			{
				case 49:
					output.Append("X");
					break;
				case 50:
					output.Append("XX");
					break;
				case 51:
					output.Append("XXX");
					break;
				case 52:
					output.Append("XL");
					break;
				case 53:
					output.Append("L");
					break;
				case 54:
					output.Append("LX");
					break;
				case 55:
					output.Append("LXX");
					break;
				case 56:
					output.Append("LXXX");
					break;
				case 57:
					output.Append("XC");
					break;
			}
		}
		else if(tmp.Length() - i == 3)
		{
			switch(tmp.GetChar(i))
			{
				case 49:
					output.Append("C");
					break;
				case 50:
					output.Append("CC");
					break;
				case 51:
					output.Append("CCC");
					break;
				case 52:
					output.Append("CD");
					break;
				case 53:
					output.Append("D");
					break;
				case 54:
					output.Append("DC");
					break;
				case 55:
					output.Append("DCC");
					break;
				case 56:
					output.Append("DCCC");
					break;
				case 57:
					output.Append("CM");
					break;
			}
		}
		else if(tmp.Length() - i == 4)
		{
			switch(tmp.GetChar(i))
			{
				case 49:
					output.Append("M");
					break;
				case 50:
					output.Append("MM");
					break;
				case 51:
					output.Append("MMM");
					break;
				case 52:
					output.Append("CD");
					break;
				case 53:
					output.Append("D");
					break;
				case 54:
					output.Append("DC");
					break;
				case 55:
					output.Append("DCC");
					break;
				case 56:
					output.Append("DCCC");
					break;
				case 57:
					output.Append("CM");
					break;
			}
		}

	}
	return output;
}

