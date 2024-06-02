class UserModel{
 String? uid;
 String? email;
 String? pass;
 String? mob;
 String? gender;
 String? name;

 UserModel({required this.email, required this.pass, required this.mob,required  this.gender, required this.name,required this.uid});
  factory UserModel.fromDoc(Map<String,dynamic>doc){
    return UserModel(
        email: doc['email'],
        pass: doc['pass'],
        mob: doc['mob'],
        gender: doc['gender'],
        name: doc['name'],
      uid: doc['uid'],
    );
  }

  Map<String,dynamic>toDoc(){
    return {
      'email':email,
      'pass':pass,
      'mob':mob,
      'gender':gender,
      'name':name,
      'uid':uid,
    };
  }
}