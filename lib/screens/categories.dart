import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:power_campus/screens/courses.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
  });

  @override
  State<CategoriesScreen> createState() {
    return _StateCategoriesScreen();
  }
}

class _StateCategoriesScreen extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Categories'),
        foregroundColor: Color.fromARGB(255, 7, 6, 41),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Categories').snapshots(),
          builder: (ctx, categorySnapshots) {
            if (categorySnapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final categories = categorySnapshots.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(17),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                final category = categories[index];
                final categoryname = category['name'];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                CoursesScreen(categoryname: categoryname)));
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // border:
                      //     Border.all(color: Color.fromARGB(255, 16, 28, 54)),
                      borderRadius: BorderRadius.circular(16),
                      color: Color.fromARGB(255, 164, 190, 224),
                    ),
                    child: Center(
                        child: Text(
                      categoryname,
                      style: const TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              },
            );
          }),
    );
  }
}
