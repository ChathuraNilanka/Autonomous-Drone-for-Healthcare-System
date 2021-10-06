
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/faq_model.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  Repository _repository = Repository();
  List<DocumentSnapshot> _documents = List();
  Future _future = Repository().getAllFAQs();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      page: DrawerPages.faq,
      child: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            Container(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      suffixIcon: Icon(Icons.search),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (String text){
                      Future future = _repository.getAllFAQs();
                      if(text.isNotEmpty){
                        future = _repository.searchFAQs(text);
                      }
                      setState(() {
                        _future = future;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return LoadingWidget();
                  QuerySnapshot querySnapshot = snapshot.data;
                  _documents = querySnapshot.documents;
                  return _buildFAQList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildFAQList() {
    return ListView.builder(
      itemCount: _documents.length,
      itemBuilder: (context,index){
        FAQModel _faq = FAQModel.fromMap(_documents[index].data);
        return _faqListItem(_faq);
      },
    );
  }
  Widget _faqListItem(FAQModel faqList) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(faqList.question,style: Theme.of(context).textTheme.headline6,),
        contentPadding: const EdgeInsets.all(8.0),
        subtitle: Text(faqList.answer,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.038),),
      ),
    );
  }
}
