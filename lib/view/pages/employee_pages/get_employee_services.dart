import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/bloc/services/services_cubit.dart';
import 'edit_service.dart';

class GetEmployeeServices extends StatefulWidget {
  const GetEmployeeServices({Key? key}) : super(key: key);

  @override
  State<GetEmployeeServices> createState() => _GetEmployeeServicesState();
}

class _GetEmployeeServicesState extends State<GetEmployeeServices> {
  @override
  void initState() {
    context.read<ServicesCubit>().getServices();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Employee Services'),
        ),
        body: BlocConsumer<ServicesCubit, ServicesState>(
            listener: (context, state) {},
            builder: (context, state) {
              return (state is GetServiceLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : (ServicesCubit.get(context).serviceModel.isNotEmpty)
                      ? ListView.separated(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Title : ${ServicesCubit.get(context).serviceModel[index].title}",
                                    style: const TextStyle(fontSize: 20),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "price : ${ServicesCubit.get(context).serviceModel[index].cost.toString()}",
                                    style: const TextStyle(fontSize: 20),
                                  )),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return EditService(
                                                  index: index,
                                                );
                                              },
                                            ));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            ServicesCubit.get(context)
                                                .deleteService(
                                                    id: ServicesCubit.get(
                                                            context)
                                                        .serviceModel[index]
                                                        .id);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          ),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount:
                              ServicesCubit.get(context).serviceModel.length,
                        )
                      : const Center(
                          child: Text("No Services Yet"),
                        );
            }));
  }
}
