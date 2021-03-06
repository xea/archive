#include <sqlite.h>

class wSQLiteDB
{
	public:
		int Open(const char* dbase); 	// adatbazis megnyitasa, parameternek a filenevet megadni
		void Close(void); 						// adatbazis bezarasa
		char *err; 										// a parancs nyugtazasa, NULL ha minden rendben volt
		sqlite *db; 									// maga az adatbazis
	private:
};

class wSQLiteQuery:public wSQLiteDB
{
	public:
		void GetTable(const char* sql); // sql parancs vegrehajtasa, parameternek a szabvanyos sql 
		void FreeTable(void); 					// a GetTable utan ezt kell meghivni az eredmenytabla felszabaditasahoz
		int numcols;  									// az eredmenytabla oszlopainak a szama
		int numrows;  									// az eredmenytabla sorainak a szama
		char **result;  								// maga az eredmenytabla
	private:
};

int wSQLiteDB::Open(const char * dbase)
{
	this->db = sqlite_open(dbase, 0, &(this->err));
	return 1;
}

void wSQLiteDB::Close(void)
{
	sqlite_close(this->db);
}

// class definitions 

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


     