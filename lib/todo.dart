class Todo {
   int id;
   String title;
   bool selected;


  Todo({this.id, this.title, this.selected,});

   set setId(int id) { 
      this.id = id; 
   } 

   int get getId{
     return this.id;
   }

     set setTitle(String title) { 
      this.title = title; 
   } 

   String get getTitle{
     return this.title;
   }

    set setSelected(bool selected) { 
      this.selected = selected; 
   } 

   bool get getSelected{
     return this.selected;
   }

   Todo.fromJson(Map<String, dynamic> list){
     this.id = list["id"];
     this.selected = list["selected"];
     this.title = list["title"];
   }

   Map<String, dynamic> toJson() =>{
     'id': this.id,
     'title': this.title,
     'selected': this.selected,
   };

}
