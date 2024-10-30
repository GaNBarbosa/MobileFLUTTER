class Book{

  int _id = 0;
  String _title = "";
  String _author = "";
  String _editor = "";
  String _category = "";
  String _cover = "";
  int _fullStock = 0;
  int _actualStock = 0;
  int _acesses = 0;
 
  int get id => this._id;
  set id(int value) => this._id = value;

  get title => this._title;
  set title( value) => this._title = value;

  get author => this._author;
  set author( value) => this._author = value;

  get editor => this._editor;
  set editor( value) => this._editor = value;

  get category => this._category;
  set category( value) => this._category = value;

  get cover => this._cover;
  set cover( value) => this._cover = value;

  get fullStock => this._fullStock;
  set fullStock( value) => this._fullStock = value;

  get actualStock => this._actualStock;
  set actualStock( value) => this._actualStock = value;

  get acesses => this._acesses;
  set acesses( value) => this._acesses = value;

  Book();

  Book.fromJson(Map<String, dynamic> json):
  _id = json['id'],
  _title = json['title'],
  _author = json['author'],
  _editor = json['editor'],
  _category = json['category'],
  _cover = json['cover'],
  _fullStock = json['fullStock'],
  _actualStock = json['actualStock'],
  _acesses = json['acesses']
  ;
  
}