import 'package:crypto_bloc/blocs/crypto/crypto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_bloc/blocs/crypto/crypto_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final _cryptoRepository = CryptoRepository();
  // int _page = 0;

  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crpto Chart!'),
      ),
      body: SafeArea(
        child: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.9,
                  ],
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.grey[900].withOpacity(0.9),
                  ],
                ),
              ),
              child: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
        ),
      );
    } else if (state is CryptoLoaded) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          context.bloc<CryptoBloc>().add(
                RefreshCoins(),
              );
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.coins.length,
            itemBuilder: (BuildContext context, int index) {
              final coin = state.coins[index];
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${++index}',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  coin.fullName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  coin.name,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: Text(
                  '\$${coin.price.toStringAsFixed(4)}',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (state is CryptoError) {
      return Center(
        child: Text(
          'Error loading coins!\n PLease check your connection',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18.0,
          ),
        ),
      );
    }
  }

  bool _onScrollNotification(ScrollNotification notif, CryptoLoaded state) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      context.bloc<CryptoBloc>().add(LoadMoreCoins(coins: state.coins));
    }
    return false;
  }
}

//       FutureBuilder(
//           future: _cryptoRepository.getTopCoins(page: _page),
//           builder: (context, snapshot) {
//             if (!snapsh;
//   },
// )ot.hasData) {
//         return Center(
//           child: CircularProgressIndicator(
//             valueColor:
//                 AlwaysStoppedAnimation(Theme.of(context).accentColor),
//           ),
//         );
//       }
//       // store coin data (this is list format)
//       final List<Coin> coins = snapshot.data;
//       return RefreshIndicator(
//         color: Theme.of(context).accentColor,
//         onRefresh: () async {
//           setState(() => _page = 0);
//         },
//         child: ListView.builder(
//           itemCount: coins.length,
//           itemBuilder: (BuildContext context, int index) {
//             final coin = coins[index];
//             return ListTile(
//               leading: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${++index}',
//                     style: TextStyle(
//                       color: Theme.of(context).accentColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               title: Text(
//                 coin.fullName,
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//               subtitle: Text(
//                 coin.name,
//                 style: TextStyle(
//                   color: Colors.white70,
//                 ),
//               ),
//               trailing: Text(
//                 '\$${coin.price.toStringAsFixed(4)}',
//                 style: TextStyle(
//                   color: Theme.of(context).accentColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
