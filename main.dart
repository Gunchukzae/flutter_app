import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Item 클래스 정의
class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

// 2. CartModel 클래스 정의 (ChangeNotifier를 상속받아 상태 관리)
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addItem(Item item) {
    _items.add(item);
    notifyListeners(); // 상태 변경 후 UI 갱신
  }

  void removeAll() {
    _items.clear();
    notifyListeners(); // 상태 변경 후 UI 갱신
  }
}

// 3. SomeOtherClass - 예시로 다른 클래스 추가
class SomeOtherClass {
  final String description = 'This is some other class';
}

// 4. MyCatalog 페이지 - 상품 목록을 보여주는 페이지
class MyCatalog extends StatelessWidget {
  const MyCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Item> catalogItems = [
      Item(name: 'Product 1', price: 30.0),
      Item(name: 'Product 2', price: 50.0),
      Item(name: 'Product 3', price: 70.0),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Catalog')),
      body: ListView.builder(
        itemCount: catalogItems.length,
        itemBuilder: (context, index) {
          final item = catalogItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price}'),
            trailing: ElevatedButton(
              onPressed: () {
                // CartModel을 구독하여 아이템을 추가
                Provider.of<CartModel>(context, listen: false).addItem(item);
              },
              child: const Text('Add to Cart'),
            ),
          );
        },
      ),
      
      
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // MyCart 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCart()),
          );
        },
        tooltip: 'Go to Cart',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

// 5. MyCart 페이지 - 카트에 추가된 아이템과 합계 금액을 보여주는 페이지
class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    // CartModel을 구독하여 카트 아이템 가져오기
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Column(
        children: <Widget>[
          if (cart.items.isEmpty)
            const Center(child: Text('Your cart is empty!')),
          if (cart.items.isNotEmpty)
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Price: \$${cart.totalPrice}', style: Theme.of(context).textTheme.headlineLarge),
          ),
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

// 6. MyApp 클래스 - 앱의 시작점
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()), // CartModel을 하위 위젯에 제공
        Provider(create: (context) => SomeOtherClass()), // SomeOtherClass를 하위 위젯에 제공
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Cart Example',
      home: MyCatalog(),  // 초기 페이지는 MyCatalog
    );
  }
}
