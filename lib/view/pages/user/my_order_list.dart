import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/order_cubit/order_cubit.dart';
import 'package:graduation_project/view_model/database/local/sql_lite.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../code/constants_value.dart';
import '../../../view_model/bloc/get_price/get_price_cubit.dart';

class MyOrderList extends StatefulWidget {
  const MyOrderList({Key? key}) : super(key: key);

  @override
  State<MyOrderList> createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList> {
  num totalPrice = 0;

  GetPriceCubit priceCubit = GetPriceCubit();
  List<int> priceList = [];

  @override
  Widget build(BuildContext context) {
    priceList.clear();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderCubit()..getOrderData(),
        ),
        BlocProvider(
          create: (context) =>
              priceCubit..totalPrice(OrderCubit.get(context).product),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Order List"),
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            var orderCubit = OrderCubit.get(context);
            priceCubit.totalPrice(OrderCubit.get(context).product);
            return ModalProgressHUD(
              inAsyncCall: state is SendDataToDataBaseLoading,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: ListView.builder(
                    itemCount: orderCubit.product.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 0.1.sh,
                                  width: 0.2.sw,
                                  child: Image.network(
                                    orderCubit.product[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (orderCubit
                                                    .product[index].quantity >
                                                1) {
                                              orderCubit
                                                  .product[index].quantity--;
                                              priceCubit.totalPrice(
                                                  orderCubit.product);
                                            }
                                            SQLHelper.updateCardOrder(
                                              idProduct:
                                                  orderCubit.product[index].id,
                                              quantity: orderCubit
                                                  .product[index].quantity,
                                            ).then((value) {
                                              setState(() {

                                              });
                                              if (kDebugMode) {
                                                print("update");
                                              }
                                            });
                                          });
                                        },
                                        icon: const Icon(Icons.remove)),
                                    const Text("Quantity : "),
                                    Text(orderCubit.product[index].quantity
                                        .toString()),
                                    IconButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          FirebaseFirestore.instance
                                              .collection('product')
                                              .doc(orderCubit.product[index].id)
                                              .get()
                                              .then((value) {
                                            if (value.data()!['quantity'] >
                                                orderCubit
                                                    .product[index].quantity) {
                                              setState(() {
                                                orderCubit
                                                    .product[index].quantity++;
                                                priceCubit.totalPrice(
                                                    orderCubit.product);
                                                SQLHelper.updateCardOrder(
                                                  idProduct: orderCubit
                                                      .product[index].id,
                                                  quantity: orderCubit
                                                      .product[index].quantity,
                                                ).then((value) {
                                                  if (kDebugMode) {
                                                    print("update");
                                                  }
                                                });
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Sorry, we don't have enough quantity")));
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.add)),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              orderCubit.product[index].title.toString(),
                            ),
                            Column(
                              children: [
                                Text(
                                    orderCubit.product[index].price.toString()),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        SQLHelper.deleteCardOrder(
                                                idProduct: orderCubit
                                                    .product[index].id)
                                            .then((value) {
                                          orderCubit.product.removeAt(index);
                                          setState(() {

                                          });
                                          if (kDebugMode) {

                                            print("delete");
                                          }
                                        });
                                      });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        bottomSheet: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return InkWell(
              onTap: () async {
                OrderCubit.get(context).sendData(context).whenComplete(() {
                  OrderCubit.get(context).product.clear();
                  OrderCubit.get(context).RemoveData();
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Your order has been sent successfully")));
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color:buttonColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                    )
                  ]
                ),
                height: 0.1.sh,
                width: 1.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Total Price",
                      style: TextStyle(color: Colors.white),
                    ),
                    BlocConsumer<GetPriceCubit, GetPriceState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        return Text("${GetPriceCubit.get(context).total} EGP",
                            style: const TextStyle(color: Colors.white));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
