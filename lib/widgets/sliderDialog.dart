
import 'package:flutter/material.dart';

Future sliderDialog({required BuildContext context,required double min,required double max,
                     required double value,required String changeText,required  int div}){

  return showDialog(context: context, builder: (ctx){
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Dialog(

          backgroundColor: Colors.teal.shade50,


          child: SizedBox(
            height: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top:20,left: 20,),
                  child: Text(changeText,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 10),
                  child: Text(value.toString(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    valueIndicatorColor: Colors.indigo, // This is what you are asking for
                    activeTrackColor: Colors.white,

                  ),
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: div,
                    // label: "$value",

                    activeColor: Colors.indigo,
                    thumbColor: Colors.white,
                    onChanged: (va) {
                      value = va;
                        setState((){});
                    },
                  ),
                ),


                  Padding(
                    padding: const EdgeInsets.only(right: 15,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context,),
                          child: const Text('cancel',style: TextStyle(color: Colors.indigo),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, value),
                          child:  const Text('confirm',style: TextStyle(color: Colors.indigo)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    );
  });
}