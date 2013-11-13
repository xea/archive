#include "wx/wxprec.h"

#ifdef __BORLANDC__
		#pragma hdrstop
#endif

#if defined(__WXGTK__) || defined(__WXMOTIF__) || defined(__WXMAC__) || defined(__WXMGL__) || defined(__WXX11__)
		#include "mondrian.xpm"
#endif

#include <wx/wx.h>
#include <wx/calctrl.h>
#include <wx/filedlg.h>
#include <wx/image.h>
#include <wx/splitter.h>
#include <wx/listctrl.h>
#include <wx/spinctrl.h>
#include <wx/utils.h>
#include <wx/timer.h>
#include <sqlite.h>
#include "wsqlite.h"

class wDlgCatProp: public wxDialog 
{
	public:
		wDlgCatProp(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_DIALOG_STYLE);
	private:
		void set_properties();
		void do_layout();
	protected:
		wxTextCtrl* t_cp_long;
		wxTextCtrl* t_cp_short;
		wxButton* b_cp_ok;
		wxButton* b_cp_cancel;
};

class wDlgAreProp: public wxDialog 
{
	public:
		wDlgAreProp(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_DIALOG_STYLE);
	private:
		void set_properties();
		void do_layout();
	protected:
		wxTextCtrl* t_ap_long;
		wxTextCtrl* t_ap_short;
		wxButton* b_ap_ok;
		wxButton* b_ap_cancel;
};


class wDlgTocProp: public wxDialog 
{
	public:
		wDlgTocProp(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_DIALOG_STYLE);
	private:
		void set_properties();
		void do_layout();
	protected:
		wxSpinCtrl* sp_tp_cyear;
		wxChoice* ch_tp_cmonth;
		wxSpinCtrl* sp_tp_cday;
		wxSpinCtrl* sp_tp_no;
		wxChoice* ch_tp_cat;
		wxTextCtrl* tx_tp_label;
		wxSpinCtrl* sp_tp_hyear;
		wxChoice* ch_tp_hmonth;
		wxSpinCtrl* sp_tp_hday;
		wxChoice* ch_tp_area;
		wxButton* b_tp_ok;
		wxButton* b_tp_cancel;
};


class wEditor: public wxFrame 
{
	public:
		wEditor(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_FRAME_STYLE);
	private:
		void set_properties();
		void do_layout();
	protected:
		wxTextCtrl* tx_edi_editor;
		wxButton* b_edi_ok;
		wxButton* b_edi_cancel;
		wxPanel* p_editor;
};

class wRoot: public wxFrame 
{
	public:
		wRoot(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_FRAME_STYLE);
		void OnQuit(wxCommandEvent& event);
		void OnNewToc(wxCommandEvent& event);
		void OnNewCat(wxCommandEvent& event);
		void OnNewAre(wxCommandEvent& event);
		void OpenDB(wxCommandEvent& event);
		wDlgTocProp * tocprop;
		wDlgCatProp * catprop;
		wDlgAreProp * areprop;
		wSQLiteQuery * db;
		wxFileDialog * openfile;
private:
		void set_properties();
		void do_layout();
		DECLARE_EVENT_TABLE()

protected:
		wEditor* f_editor;
		wxMenuBar* f_root_menubar;
		wxStatusBar* f_root_statusbar;
		wxListCtrl* list_toc;
		wxButton* b_toc_new;
		wxButton* b_toc_insert;
		wxButton* b_toc_delete;
		wxButton* b_toc_edit;
		wxButton* b_toc_up;
		wxButton* b_toc_down;
		wxListCtrl* list_cat;
		wxButton* b_cat_new;
		wxButton* b_cat_insert;
		wxButton* b_cat_delete;
		wxButton* b_cat_edit;
		wxButton* b_cat_up;
		wxButton* b_cat_down;
		wxListCtrl* list_are;
		wxButton* b_are_new;
		wxButton* b_are_insert;
		wxButton* b_are_delete;
		wxButton* b_are_edit;
		wxButton* b_are_up;
		wxButton* b_are_down;
		wxPanel* panel_root;
};

class ProAdmin : public wxApp
{
	public:
		virtual bool OnInit();
		wRoot * root;
};

enum
{
		mFile_Quit = 1,
		mFile_Open,
		peditor,
		btocnew,
		btocinsert,
		btocdelete,
		btocedit,
		btocup,
		btocdown,
		bcatnew,
		bcatinsert,
		bcatdelete,
		bcatedit,
		bcatup,
		bcatdown,
		barenew,
		bareinsert,
		baredelete,
		bareedit,
		bareup,
		baredown,
		btpok,
		btpcancel,
		tcplong,
		tcpshort,
		taplong,
		tapshort,
		bcpok,
		bcpcancel,
		bapok,
		bapcancel,
		bediok,
		bedicancel,
		sptpyear,
		sptpcday,
		sptpno,
		sptphyear,
		sptphday,
		chtpcmonth,		
		chtpcat,
		chtphmonth,
		chtparea,
		txtplabel,
		txedieditor,
		listtoc,
		listcat,
		listare,
		dtp,
		dcp,
		dap,
		mHelp_About = wxID_ABOUT
};

// #############################################################################################################
//														event table
// #############################################################################################################

BEGIN_EVENT_TABLE(wRoot, wxFrame)
	EVT_MENU(mFile_Quit, wRoot::OnQuit)
	EVT_MENU(mFile_Open, wRoot::OpenDB)
	EVT_BUTTON(btocnew, wRoot::OnNewToc)
	EVT_BUTTON(barenew, wRoot::OnNewAre)
	EVT_BUTTON(bcatnew, wRoot::OnNewCat)
END_EVENT_TABLE()

IMPLEMENT_APP(ProAdmin)

