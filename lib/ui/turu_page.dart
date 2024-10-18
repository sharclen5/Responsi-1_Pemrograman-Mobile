import 'package:flutter/material.dart';
import '/bloc/logout_bloc.dart';
import '/bloc/turu_bloc.dart';
import '/model/turu.dart';
import '/ui/login_page.dart';
import '/ui/turu_detail.dart';
import '/ui/turu_form.dart';

class PemantauanTidurPage extends StatefulWidget {
  const PemantauanTidurPage({super.key});
  @override
  _PemantauanTidurPageState createState() => _PemantauanTidurPageState();
}

class _PemantauanTidurPageState extends State<PemantauanTidurPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemantauan Tidur'),
        backgroundColor: const Color.fromARGB(255, 255, 166, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 236, 68),
      body: FutureBuilder<List>(
        future: PemantauanTidurBloc.getPemantauanTidurs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Stack(
                  children: [
                    ListPemantauanTidur(
                      list: snapshot.data,
                    ),
                    Positioned(
                      bottom: 20.0,
                      left: MediaQuery.of(context).size.width * 0.5 - 28,
                      child: FloatingActionButton(
                        onPressed: () async {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PemantauanTidurForm()),
                          );
                          if (result == true) {
                            setState(() {});
                          }
                        },
                        child: const Icon(Icons.add),
                        backgroundColor: const Color.fromARGB(255, 255, 166, 0),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ListPemantauanTidur extends StatelessWidget {
  final List? list;
  const ListPemantauanTidur({super.key, this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPemantauanTidur(
          pemantauanTidur: list![i],
        );
      },
    );
  }
}

class ItemPemantauanTidur extends StatelessWidget {
  final PemantauanTidur pemantauanTidur; // Replace with correct model
  const ItemPemantauanTidur({super.key, required this.pemantauanTidur});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Await the result from the detail page
        bool? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PemantauanTidurDetail(
              pemantauanTidur: pemantauanTidur,
            ),
          ),
        );

        if (result == true) {
          // Refresh the page by calling setState on the parent widget
          (context as Element).markNeedsBuild();
        }
      },
      child: Card(
        color: const Color.fromARGB(
            255, 255, 174, 0), // Change this to the color you want
        child: ListTile(
          title: Text('Sleep Quality: ${pemantauanTidur.sleepQuality}'),
          subtitle: Text('Hours: ${pemantauanTidur.sleepHours}'),
        ),
      ),
    );
  }
}
