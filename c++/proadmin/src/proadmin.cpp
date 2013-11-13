#include "proadmin.h"


bool ProAdmin::OnInit()
{
	root = new wRoot(NULL, -1, _T("ProAdmin"), wxPoint(0, 0), wxSize(640, 480));
	root->Show(TRUE);
	return TRUE;
}
                          
wRoot::wRoot(wxWindow* parent, int id, const wxString& title, const wxPoint& pos, const wxSize& size, long style):
		wxFrame(parent, id, title, pos, size, wxDEFAULT_FRAME_STYLE | wxMAXIMIZE)
{                           
	panel_root = new wxPanel(this, -1);
	f_root_menubar = new wxMenuBar();          
	SetMenuBar(f_root_menubar);
	wxMenu* menuFile = new wxMenu();
	menuFile->Append(mFile_Open, wxT("Megnyitás"), wxT(""), wxITEM_NORMAL);
	menuFile->Append(mFile_Quit, wxT("Quit"), wxT(""), wxITEM_NORMAL);
	f_root_menubar->Append(menuFile, wxT("File"));
	f_root_statusbar = CreateStatusBar(1);
	list_toc = new wxListCtrl(panel_root, listtoc, wxDefaultPosition, wxDefaultSize, wxLC_REPORT|wxSUNKEN_BORDER);
	b_toc_new = new wxButton(panel_root, btocnew, wxT("Új"));
	b_toc_insert = new wxButton(panel_root, btocinsert, wxT("Beszúrás"));
	b_toc_delete = new wxButton(panel_root, btocdelete, wxT("Törlés"));
	b_toc_edit = new wxButton(panel_root, btocedit, wxT("Szerkesztés"));
	b_toc_up = new wxButton(panel_root, btocup, wxT("Fel"));
	b_toc_down = new wxButton(panel_root, btocdown, wxT("Le"));
	list_cat = new wxListCtrl(panel_root, listcat, wxDefaultPosition, wxDefaultSize, wxLC_REPORT|wxSUNKEN_BORDER);
	b_cat_new = new wxButton(panel_root, bcatnew, wxT("Új"));
	b_cat_insert = new wxButton(panel_root, bcatinsert, wxT("Beszúrás"));
	b_cat_delete = new wxButton(panel_root, bcatdelete, wxT("Törlés"));
	b_cat_edit = new wxButton(panel_root, bcatedit, wxT("Szerkesztés"));
	b_cat_up = new wxButton(panel_root, bcatup, wxT("Fel"));
	b_cat_down = new wxButton(panel_root, bcatdown, wxT("Le"));
	list_are = new wxListCtrl(panel_root, listare, wxDefaultPosition, wxDefaultSize, wxLC_REPORT|wxSUNKEN_BORDER);
	b_are_new = new wxButton(panel_root, barenew, wxT("Új"));
	b_are_insert = new wxButton(panel_root, bareinsert, wxT("Beszúrás"));
	b_are_delete = new wxButton(panel_root, baredelete, wxT("Törlés"));
	b_are_edit = new wxButton(panel_root, bareedit, wxT("Szerkesztés"));
	b_are_up = new wxButton(panel_root, bareup, wxT("Fel"));
	b_are_down = new wxButton(panel_root, baredown, wxT("Le"));
	set_properties();
	do_layout();
}

void wRoot::set_properties()
{
	SetTitle(wxT("ProAdmin"));
	wxIcon _icon;
	_icon.CopyFromBitmap(wxBitmap(wxT("D:\\Dev-Cpp\\forms\\birthday3_postcard.gif"), wxBITMAP_TYPE_ANY));
	SetIcon(_icon);
	int f_root_statusbar_widths[] = { -1 };
	f_root_statusbar->SetStatusWidths(1, f_root_statusbar_widths);
	const wxString f_root_statusbar_fields[] = { wxT("ProAdmin development") };
	for(int i = 0; i < f_root_statusbar->GetFieldsCount(); ++i) 
	{
			f_root_statusbar->SetStatusText(f_root_statusbar_fields[i], i);
	}
}


void wRoot::do_layout()
{
	wxBoxSizer* s_root = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer* s_dist = new wxBoxSizer(wxVERTICAL);
	wxStaticBoxSizer* s_are = new wxStaticBoxSizer(new wxStaticBox(panel_root, -1, wxT("Jogterületek")), wxVERTICAL);
	wxBoxSizer* s_are_buttons = new wxBoxSizer(wxHORIZONTAL);
	wxStaticBoxSizer* s_cat = new wxStaticBoxSizer(new wxStaticBox(panel_root, -1, wxT("Kategóriák")), wxVERTICAL);
	wxBoxSizer* s_cat_buttons = new wxBoxSizer(wxHORIZONTAL);
	wxStaticBoxSizer* s_toc = new wxStaticBoxSizer(new wxStaticBox(panel_root, -1, wxT("Tartalomjegyzék")), wxVERTICAL);
	wxBoxSizer* s_toc_buttons = new wxBoxSizer(wxHORIZONTAL);
	s_toc->Add(list_toc, 1, wxEXPAND, 0);
	s_toc_buttons->Add(b_toc_new, 1, 0, 0);
	s_toc_buttons->Add(b_toc_insert, 1, 0, 0);
	s_toc_buttons->Add(b_toc_delete, 1, 0, 0);                                                             
	s_toc_buttons->Add(b_toc_edit, 1, 0, 0);
	s_toc_buttons->Add(b_toc_up, 1, 0, 0);
	s_toc_buttons->Add(b_toc_down, 1, 0, 0);
	s_toc->Add(s_toc_buttons, 0, wxEXPAND, 0);
	s_dist->Add(s_toc, 1, wxEXPAND, 0);
	s_cat->Add(list_cat, 1, wxEXPAND, 0);
	s_cat_buttons->Add(b_cat_new, 1, 0, 0);
	s_cat_buttons->Add(b_cat_insert, 1, 0, 0);
	s_cat_buttons->Add(b_cat_delete, 1, 0, 0);
	s_cat_buttons->Add(b_cat_edit, 1, 0, 0);
	s_cat_buttons->Add(b_cat_up, 1, 0, 0);
	s_cat_buttons->Add(b_cat_down, 1, 0, 0);
	s_cat->Add(s_cat_buttons, 0, wxEXPAND, 0);
	s_dist->Add(s_cat, 1, wxEXPAND, 0);
	s_are->Add(list_are, 1, wxEXPAND, 0);
	s_are_buttons->Add(b_are_new, 1, 0, 0);
	s_are_buttons->Add(b_are_insert, 1, 0, 0);
	s_are_buttons->Add(b_are_delete, 1, 0, 0);
	s_are_buttons->Add(b_are_edit, 1, 0, 0);
	s_are_buttons->Add(b_are_up, 1, 0, 0);
	s_are_buttons->Add(b_are_down, 1, 0, 0);
	s_are->Add(s_are_buttons, 0, wxEXPAND, 0);
	s_dist->Add(s_are, 1, wxEXPAND, 0);
	panel_root->SetAutoLayout(true);
	panel_root->SetSizer(s_dist);
	s_dist->Fit(panel_root);
	s_dist->SetSizeHints(panel_root);
	s_root->Add(panel_root, 1, wxEXPAND, 0);
	SetAutoLayout(true);
	SetSizer(s_root);
	s_root->Fit(this);
	s_root->SetSizeHints(this);
	Layout();
}

void wRoot::OnQuit(wxCommandEvent& event)
{
	this->Destroy();
}

void wRoot::OnNewToc(wxCommandEvent& event)
{
	tocprop = new wDlgTocProp(this, dtp, _T("Title"), wxPoint(-1, -1), wxSize(-1, -1));
	tocprop->ShowModal();
}

void wRoot::OnNewCat(wxCommandEvent& event)
{
	catprop = new wDlgCatProp(this, dcp, _T("Title"), wxPoint(-1, -1), wxSize(-1, -1));
	catprop->ShowModal();
}

void wRoot::OnNewAre(wxCommandEvent& event)
{
	areprop = new wDlgAreProp(this, dap, _T("Title"), wxPoint(-1, -1), wxSize(-1, -1));
	areprop->ShowModal();
}

void wRoot::OpenDB(wxCommandEvent& event)
{
	openfile = new wxFileDialog(this, _T("Válasszon egy filet!"), _T("."), _T(""), _T("*.*"), wxOPEN);
	openfile->ShowModal();
}

wDlgCatProp::wDlgCatProp(wxWindow* parent, int id, const wxString& title, const wxPoint& pos, const wxSize& size, long style):
		wxDialog(parent, id, title, pos, size, wxDEFAULT_DIALOG_STYLE)
{
	t_cp_long = new wxTextCtrl(this, tcplong, wxT(""));
	t_cp_short = new wxTextCtrl(this, tcpshort, wxT(""));
	b_cp_ok = new wxButton(this, bcpok, wxT("OK"));
	b_cp_cancel = new wxButton(this, bcpcancel, wxT("Mégse"));
	set_properties();
	do_layout();
}


void wDlgCatProp::set_properties()
{
	SetTitle(wxT("Kategória tulajdonságai"));
	SetSize(wxSize(300, 133));
}


void wDlgCatProp::do_layout()
{
	wxBoxSizer* s_cp = new wxBoxSizer(wxVERTICAL);
	wxBoxSizer* s_cp_buttons = new wxBoxSizer(wxHORIZONTAL);
	wxStaticBoxSizer* s_cp_short = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Rövid megnevezés")), wxHORIZONTAL);
	wxStaticBoxSizer* s_cp_long = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Teljes megnevezés")), wxHORIZONTAL);
	s_cp_long->Add(t_cp_long, 1, 0, 0);
	s_cp->Add(s_cp_long, 1, wxEXPAND, 0);
	s_cp_short->Add(t_cp_short, 1, 0, 0);
	s_cp->Add(s_cp_short, 1, wxEXPAND, 0);
	s_cp_buttons->Add(b_cp_ok, 0, 0, 0);
	s_cp_buttons->Add(b_cp_cancel, 0, 0, 0);
	s_cp->Add(s_cp_buttons, 0, wxEXPAND, 0);
	SetAutoLayout(true);
	SetSizer(s_cp);
	Layout();
}

wDlgAreProp::wDlgAreProp(wxWindow* parent, int id, const wxString& title, const wxPoint& pos, const wxSize& size, long style):
		wxDialog(parent, id, title, pos, size, wxDEFAULT_DIALOG_STYLE)
{
	t_ap_long = new wxTextCtrl(this, taplong, wxT(""));
	t_ap_short = new wxTextCtrl(this, tapshort, wxT(""));
	b_ap_ok = new wxButton(this, bapok, wxT("OK"));
	b_ap_cancel = new wxButton(this, bapcancel, wxT("Mégse"));
	set_properties();
	do_layout();
}

void wDlgAreProp::set_properties()
{
	SetTitle(wxT("Jogterület tulajdonságai"));
	SetSize(wxSize(300, 133));
}

void wDlgAreProp::do_layout()
{
	wxBoxSizer* s_ap = new wxBoxSizer(wxVERTICAL);
	wxBoxSizer* s_ap_buttons = new wxBoxSizer(wxHORIZONTAL);
	wxStaticBoxSizer* s_ap_short = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Rövid megnevezés")), wxHORIZONTAL);
	wxStaticBoxSizer* s_ap_long = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Teljes megnevezés")), wxHORIZONTAL);
	s_ap_long->Add(t_ap_long, 1, 0, 0);
	s_ap->Add(s_ap_long, 1, wxEXPAND, 0);
	s_ap_short->Add(t_ap_short, 1, 0, 0);
	s_ap->Add(s_ap_short, 1, wxEXPAND, 0);
	s_ap_buttons->Add(b_ap_ok, 0, 0, 0);
	s_ap_buttons->Add(b_ap_cancel, 0, 0, 0);
	s_ap->Add(s_ap_buttons, 0, wxEXPAND, 0);
	SetAutoLayout(true);
	SetSizer(s_ap);
	Layout();
}

wDlgTocProp::wDlgTocProp(wxWindow* parent, int id, const wxString& title, const wxPoint& pos, const wxSize& size, long style):
		wxDialog(parent, id, title, pos, size, wxDEFAULT_DIALOG_STYLE)
{
	sp_tp_cyear = new wxSpinCtrl(this, sptpyear, "", wxDefaultPosition, wxDefaultSize, wxSP_ARROW_KEYS, 0, 2200);
	const wxString ch_tp_cmonth_choices[] = {
			wxT("Január"),
			wxT("Február"),
			wxT("Március"),
			wxT("Április"),
			wxT("Május"),
			wxT("Június"),
			wxT("Július"),
			wxT("Augusztus"),
			wxT("Szeptember"),
			wxT("Október"),
			wxT("November"),       
			wxT("December")
	};                              
	ch_tp_cmonth = new wxChoice(this, chtpcmonth, wxDefaultPosition, wxDefaultSize, 12, ch_tp_cmonth_choices, 0);
	sp_tp_cday = new wxSpinCtrl(this, sptpcday, "", wxDefaultPosition, wxDefaultSize, wxSP_ARROW_KEYS, 1, 31);
	sp_tp_no = new wxSpinCtrl(this, sptpno, "", wxDefaultPosition, wxDefaultSize, wxSP_ARROW_KEYS, 0, 9999);
	const wxString ch_tp_cat_choices[] = { wxT("choice 1") };
	ch_tp_cat = new wxChoice(this, chtpcat, wxDefaultPosition, wxDefaultSize, 1, ch_tp_cat_choices, 0);
	tx_tp_label = new wxTextCtrl(this, txtplabel, wxT(""));
	sp_tp_hyear = new wxSpinCtrl(this, sptphyear, "", wxDefaultPosition, wxDefaultSize, wxSP_ARROW_KEYS, 0, 2200);
	const wxString ch_tp_hmonth_choices[] = {
			wxT("Január"),
			wxT("Február"),
			wxT("Március"),
			wxT("Április"),
			wxT("Május"),
			wxT("Június"),
			wxT("Július"),
			wxT("Augusztus"),
			wxT("Szeptember"),
			wxT("Október"),
			wxT("November"),
			wxT("December")
	};
	ch_tp_hmonth = new wxChoice(this, chtphmonth, wxDefaultPosition, wxDefaultSize, 12, ch_tp_hmonth_choices, 0);
	sp_tp_hday = new wxSpinCtrl(this, sptphday, "", wxDefaultPosition, wxDefaultSize, wxSP_ARROW_KEYS, 1, 31);
	const wxString ch_tp_area_choices[] = {
			wxT("choice 1")
	};
	ch_tp_area = new wxChoice(this, chtparea, wxDefaultPosition, wxDefaultSize, 1, ch_tp_area_choices, 0);
	b_tp_ok = new wxButton(this, btpok, wxT("OK"));
	b_tp_cancel = new wxButton(this, btpcancel, wxT("Mégse"));
	set_properties();
	do_layout();
}


void wDlgTocProp::set_properties()
{
	SetTitle(wxT("Bejegyzés tulajdonságai"));
	ch_tp_cmonth->SetSelection(0);
	ch_tp_cat->SetSelection(0);
	ch_tp_hmonth->SetSelection(0);
	ch_tp_area->SetSelection(0);
}


void wDlgTocProp::do_layout()
{
		// begin wxGlade: wDlgTocProp::do_layout
	wxBoxSizer* s_tp_dist = new wxBoxSizer(wxVERTICAL);
	wxBoxSizer* s_tp_buttons = new wxBoxSizer(wxHORIZONTAL);
	wxStaticBoxSizer* s_tp_area = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Jogterület")), wxHORIZONTAL);
	wxStaticBoxSizer* s_tp_hdate = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Hatályos")), wxHORIZONTAL);
	wxStaticBoxSizer* s_tp_title = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Cím")), wxHORIZONTAL);
	wxStaticBoxSizer* s_tp_cat = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Kategória")), wxHORIZONTAL);
	wxStaticBoxSizer* s_tp_no = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Sorszám")), wxHORIZONTAL);
	wxStaticBoxSizer* s_tp_cdate = new wxStaticBoxSizer(new wxStaticBox(this, -1, wxT("Létrehozás dátuma")), wxHORIZONTAL);
	s_tp_cdate->Add(sp_tp_cyear, 0, 0, 0);
	s_tp_cdate->Add(ch_tp_cmonth, 0, 0, 0);
	s_tp_cdate->Add(sp_tp_cday, 1, 0, 0);
	s_tp_dist->Add(s_tp_cdate, 0, wxEXPAND, 0);
	s_tp_no->Add(sp_tp_no, 1, 0, 0);
	s_tp_dist->Add(s_tp_no, 0, wxEXPAND, 0);
	s_tp_cat->Add(ch_tp_cat, 1, 0, 0);
	s_tp_dist->Add(s_tp_cat, 0, wxEXPAND, 0);
	s_tp_title->Add(tx_tp_label, 1, 0, 0);
	s_tp_dist->Add(s_tp_title, 0, wxEXPAND, 0);
	s_tp_hdate->Add(sp_tp_hyear, 0, 0, 0);
	s_tp_hdate->Add(ch_tp_hmonth, 0, 0, 0);
	s_tp_hdate->Add(sp_tp_hday, 0, 0, 0);
	s_tp_dist->Add(s_tp_hdate, 0, wxEXPAND, 0);
	s_tp_area->Add(ch_tp_area, 1, 0, 0);
	s_tp_dist->Add(s_tp_area, 0, wxEXPAND, 0);
	s_tp_buttons->Add(b_tp_ok, 0, 0, 0);
	s_tp_buttons->Add(b_tp_cancel, 0, 0, 0);
	s_tp_dist->Add(s_tp_buttons, 0, wxEXPAND, 0);
	SetAutoLayout(true);
	SetSizer(s_tp_dist);
	s_tp_dist->Fit(this);
	s_tp_dist->SetSizeHints(this);
	Layout();
}


wEditor::wEditor(wxWindow* parent, int id, const wxString& title, const wxPoint& pos, const wxSize& size, long style):
		wxFrame(parent, id, title, pos, size, wxDEFAULT_FRAME_STYLE)
{
	p_editor = new wxPanel(this, peditor);
	tx_edi_editor = new wxTextCtrl(p_editor, txedieditor, wxT(""), wxDefaultPosition, wxDefaultSize, wxTE_MULTILINE|wxTE_RICH|wxTE_RICH2);
	b_edi_ok = new wxButton(p_editor, bediok, wxT("OK"));
	b_edi_cancel = new wxButton(p_editor, bedicancel, wxT("Mégse"));
	set_properties();
	do_layout();
}


void wEditor::set_properties()
{
	SetTitle(wxT("Joganyag szerkesztése"));
	SetSize(wxSize(566, 475));
}


void wEditor::do_layout()
{
	wxBoxSizer* s_editor = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer* s_edi_dist = new wxBoxSizer(wxVERTICAL);
	wxBoxSizer* s_edi_buttons = new wxBoxSizer(wxHORIZONTAL);
	s_edi_dist->Add(tx_edi_editor, 1, wxEXPAND, 0);
	s_edi_buttons->Add(b_edi_ok, 0, 0, 0);
	s_edi_buttons->Add(b_edi_cancel, 0, 0, 0);
	s_edi_dist->Add(s_edi_buttons, 0, wxEXPAND, 0);
	p_editor->SetAutoLayout(true);
	p_editor->SetSizer(s_edi_dist);
	s_edi_dist->Fit(p_editor);
	s_edi_dist->SetSizeHints(p_editor);
	s_editor->Add(p_editor, 1, wxEXPAND, 0);
	SetAutoLayout(true);
	SetSizer(s_editor);
	Layout();
}


