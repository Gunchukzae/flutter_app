import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:collection'; // UnmodifiableListView를 사용하기 위해 필요


// Item 클래스 정의
class Item {
  final String name;
  final int price;

  Item({required this.name, required this.price});
}

// CartModel 클래스 (상태 관리)
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  // 읽기 전용 리스트 반환 (변경 불가능한 리스트)
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  // 총 가격 계산 (모든 아이템의 가격 합)
  int get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  // 아이템 추가
  void add(Item item) {
    _items.add(item);
    notifyListeners();  // 상태 변경 후 위젯 갱신
  }

  // 카트 비우기
  void removeAll() {
    _items.clear();
    notifyListeners();  // 상태 변경 후 위젯 갱신
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),  // CartModel을 제공
      child: const MaterialApp(
        title: 'Flutter Cart Example',
        home: CartScreen(),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CartModel을 사용하여 카트 정보 가져오기
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price}'),
                );
              },
            ),
          ),
          // 총 가격 표시
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total: \$${cart.totalPrice}', style: TextStyle(fontSize: 20)),
          ),
          // 카트에 아이템 추가 버튼
          ElevatedButton(
            onPressed: () {
              cart.add(Item(name: 'Item ${cart.items.length + 1}', price: 42));  // 새로운 아이템 추가
            },
            child: const Text('Add Item'),
          ),
          // 카트 비우기 버튼
          ElevatedButton(
            onPressed: () {
              cart.removeAll();  // 카트 비우기
            },
            child: const Text('Clear Cart'),
          ),
        ],
      ),
    );
  }
}
