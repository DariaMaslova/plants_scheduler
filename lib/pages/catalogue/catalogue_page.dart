import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plants_scheduler/main.dart';
import 'package:plants_scheduler/pages/catalogue/catalogue_viewmodel.dart';
import 'package:plants_scheduler/pages/catalogue/model/catalogue.dart';
import 'package:plants_scheduler/pages/home/home_page.dart';
import 'package:plants_scheduler/core/extensions/cap_extensions.dart';

import '../../routes.dart';

class CataloguePage extends StatefulWidget {

  @override
  _CatalogueState createState() => _CatalogueState();

}

class _CatalogueState extends State<CataloguePage> {

  final _viewModel = CatalogueViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel.subscribeFilter(FilterController.of(context));
    return Scaffold(
      body: StreamBuilder(
        stream: _viewModel.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: CircularProgressIndicator(),
            );
          } else {
            final state = (snapshot.data as CatalogueDataState);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _Catalogue(
                    plants: state.plants ??
                        List<CataloguePlant>(),
                    onLoadMoreListener: () {
                      _viewModel.loadMore();
                    },
                    canLoadMore: state.canLoadMore(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: state.isLoading ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _Catalogue extends StatelessWidget {
  final List<CataloguePlant> plants;
  final bool canLoadMore;
  final Function onLoadMoreListener;

  _Catalogue({Key key, this.plants, this.onLoadMoreListener, this.canLoadMore = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification:  (ScrollNotification scrollInfo) {
        if (canLoadMore && onLoadMoreListener!= null && scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 50.0) {
          onLoadMoreListener.call();
        }
        return false;
      },
      child: GridView.builder(
          padding: const EdgeInsets.all(
            16.0,
          ),
          itemCount: plants.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (context, index) => _PlantItem(
                plant: plants[index],
                isLeft: index % 2 == 0,
              )),
    );
  }
}

class _PlantItem extends StatelessWidget {
  final CataloguePlant plant;
  final bool isLeft;
  final _cornerRadius = Radius.circular(24.0);

  _PlantItem({Key key, this.plant, this.isLeft}) : super(key: key);

  BorderRadius _borderRadius() {
    if (isLeft) {
      return BorderRadius.only(
          topLeft: _cornerRadius,
          topRight: _cornerRadius,
          bottomLeft: _cornerRadius);
    } else {
      return BorderRadius.only(
          topLeft: _cornerRadius,
          topRight: _cornerRadius,
          bottomRight: _cornerRadius);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        AppNavigator.of(context)
            .pushNamed(AppRoutes.plantFeatures, arguments: plant)
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius()),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              color: Colors.grey.shade200,
              child: plant.preview != null
                  ? Image.network(
                      plant.preview,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              constraints: const BoxConstraints.expand(
                height: 48.0,
              ),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    plant.name.capitalizeFirstOfEach,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
