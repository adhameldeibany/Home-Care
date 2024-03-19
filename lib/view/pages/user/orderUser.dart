import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  void initState() {
    // TODO: implement initState
    UserCubit.get(context).getMyOrderProduct();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Order'),
          ),
          body: (state is GetMyProductLoadingState)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              :(cubit.myOrders.isNotEmpty)?ListView.builder(
                  itemCount: cubit.myOrders.length,
                  itemBuilder: (context, index) {
                    return Card(

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            cubit.myOrders[index].image,
                            width: 100,
                            height: 100,
                          ),
                          Column(
                            children: [
                              Text("total price : ${cubit.myOrders[index].price*cubit.myOrders[index].quantity}"),
                              Text("title : ${(cubit.myOrders[index].title)}"),

                            ],
                          ),
                              Text("order Status: ${cubit.myOrders[index].ordeStatus}"),

                        ],
                      ),
                    );
                  },
                ) : Center(child: Text("No order"),),
        );
      },
    );
  }

}
