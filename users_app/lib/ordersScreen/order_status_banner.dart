import 'package:flutter/material.dart';
import 'package:users_app/sellersScreen/home_screen.dart';

class StatusBanner extends StatelessWidget {

  bool? status;
  String? orderStatus;


  StatusBanner({this.status,this.orderStatus,});

  @override
  Widget build(BuildContext context) {

    String? massage;
    IconData? iconData;

    status! ? iconData=Icons.done : iconData=Icons.cancel;
    status! ? massage='Successful': massage= 'Unsuccessful';

    return Container(

      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
             },
             child: Icon(Icons.arrow_back_rounded,color: Colors.black,),
           ),
          const SizedBox(width: 15,),
           Text(
             orderStatus =='ended'
                 ?'parcel delivered $massage'
                 :  orderStatus== 'shifted'
                     ? 'order shifted $massage'
                     :  orderStatus =='normal'
                        ?  'order Placed $massage'
                        :''
           ,
             style: const TextStyle(color:Colors.black,fontSize: 16),
           ) ,
          const SizedBox(width: 5,),
          CircleAvatar(
             radius: 14,
             backgroundColor: Colors.black,
             child: Center(
               child: Icon(
                 iconData,
                 color: Colors.white,
                 size: 16,
               ),
             ),
          ),
        ],
      ),
    );
  }
}
