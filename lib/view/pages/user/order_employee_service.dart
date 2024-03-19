import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';

class ShowOrderEmployeeService extends StatefulWidget {
  const ShowOrderEmployeeService({Key? key}) : super(key: key);

  @override
  State<ShowOrderEmployeeService> createState() => _ShowOrderEmployeeServiceState();
}

class _ShowOrderEmployeeServiceState extends State<ShowOrderEmployeeService> {
  @override
  void initState() {
    // TODO: implement initState
    UserCubit.get(context).getMyServiceOrder();

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
              :(cubit.myServiceOrders.isNotEmpty)?ListView.builder(
            itemCount: cubit.myServiceOrders.length,
            itemBuilder: (context, index) {
              return InkWell(

                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("total price : ${cubit.myServiceOrders[index].cost}"),
                              Text("titile : ${cubit.myServiceOrders[index].title}"),
                            ],
                          ),
                          Text("order Status: ${cubit.myServiceOrders[index].status}"),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ):const Center(child: Text("No Order"),),
        );
      },
    );
  }
}
