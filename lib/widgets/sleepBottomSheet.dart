
import 'package:flutter/material.dart';

Future sleepBottomSheet({required BuildContext context,}){
  
  return showModalBottomSheet(context: context, backgroundColor: Colors.teal.shade50,builder: (ctx){
    const List<int> numbers = [1,2,3,4,5,6,7,8,9,12,0,10];
    String val = '0';
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SizedBox(
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Center(

                      child: Text('$val min', style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w400),),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            boxShadow: const [BoxShadow(color: Colors.grey,blurRadius: 2,blurStyle: BlurStyle.normal)],

                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: IconButton(onPressed: (){
                            Navigator.of(context).pop(int.parse(val));
                          }, icon: const Icon(Icons.done,color: Colors.white,))),
                    ),
                  )
                ],
              ),
              SizedBox(
                  height: 270,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 1.3,
                    physics: const NeverScrollableScrollPhysics(),
                    children: numbers.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          child: (e != 12 && e != 10) ? Center(
                              child: MaterialButton(
                                  onPressed: () {


                                    if(val.length == 1 && val == '0'){
                                      val = '';
                                    }else if(val.length == 3){
                                      return;
                                    }
                                    val = val + e.toString();
                                    setState((){});


                                  },
                                  child: Center(
                                    child: Text(e.toString(),
                                      style: const TextStyle(fontSize: 25),),
                                  )))
                              : (e != 12) ? MaterialButton(
                              onPressed: () {


                                if(val.length == 1 && val == '0') {
                                  return;
                                }else if(val.length == 1){
                                  val = '0';
                                }else{
                                  val = val.substring(0 , val.length -1);
                                }
                                setState((){});


                              },
                              child: const Icon(Icons.backspace,))
                              : Container(),
                        ),
                      );
                    }).toList(),
                  )
              ),
            ],
          ),
        );
      });
  });
}