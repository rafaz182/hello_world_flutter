import 'dart:developer';

import 'package:btg_flutter_test/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '';

//app entry point
void main() {
  runApp(new MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => ExchangeRoute(),
      '/currencies': (context) => CurrenciesRoute(),
    },
  ));
}

/*class MyAppPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState()  => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  String textToShow = "I Like Flutter";
  bool toggle = true;

  void _updateText() {
    setState(() {
      if (toggle)
        textToShow = "Flutter is Awesome!";
      else
        textToShow = "I Like Flutter";

      toggle = !toggle;
    });
  }

  Widget _getToggleChild() {
    if (toggle) {
      return Text(textToShow);
    } else {
      return ElevatedButton(onPressed: () {}, child: Text(textToShow));
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        //leading: new Icon(Icons.menu), //automatically added when added drawer
        title: new Text("My Title"),
        actions: [
          new IconButton(
              icon: new Icon(Icons.shopping_cart), onPressed: () {}),
          new IconButton(
              icon: new Icon(Icons.monetization_on), onPressed: () {})
        ],
      ),
      backgroundColor: Colors.yellowAccent,
      body: new Container(
        color: Colors.red,
        child: Center(child: _getToggleChild()),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("Drawer Header"),
              decoration: new BoxDecoration(
                color: Colors.blue,
              ),
            ),
            new Text("Item 1"),
            new Text("Item 2"),
            new Text("Item 3"),
            new Text("Item 4"),
            new Text("Item 5"),
            new Text("Item 6"),
          ],
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(items: [
        new BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Home"),
        new BottomNavigationBarItem(icon: new Icon(Icons.search), label: "Search")
      ]),
      floatingActionButton: new FloatingActionButton(onPressed: _updateText, child: new Icon(Icons.add)),
    );
  }

}*/

class ExchangeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency API"),
      ),
      body: ExchangeBody(),
    );
  }
}

class ExchangeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExchangeBodyState();
}

class _ExchangeBodyState extends State<ExchangeBody> {
  String fromCurrency;
  String toCurrency;
  bool enableFetch = false;
  String conversion;

  _navigateAndGetFromCurrency(BuildContext context) async {
    final result = await Navigator.pushNamed(context, "/currencies");
    setState(() {
      fromCurrency = result;
      enableFetch = fromCurrency != null && toCurrency != null;
    });
  }

  _navigateAndGetToCurrency(BuildContext context) async {
    final result = await Navigator.pushNamed(context, "/currencies");
    setState(() {
      toCurrency = result;
      enableFetch = fromCurrency != null && toCurrency != null;
    });
  }

  _onConvertPress() {
    fetchCurrencies().then((value) => _convertCurrencies(value));
  }

  Future<CurrencyDTO> fetchCurrencies() async {
    final response =
    await http.get('http://apilayer.net/api/live?access_key=7939e9a7ca8b45ae8492775e99d9bcdf&currencies=$fromCurrency,$toCurrency&source=USD&format=1');

    if (response.statusCode == 200) {
      return CurrencyDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  _convertCurrencies(CurrencyDTO currency) {
    setState(() {
      num fromValue = currency.quotes.data['${currency.source}$fromCurrency'];
      num toValue = currency.quotes.data['${currency.source}$toCurrency'];
      num factor = toValue / fromValue ;
      conversion = "1 $fromCurrency = ${factor.toStringAsFixed(2)} $toCurrency";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: [
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 2),
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Padding(
                  child: Text(fromCurrency ?? "Tap to select"),
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                ),
              ),
            ),
            onTap: () {
              _navigateAndGetFromCurrency(context);
            },
          ),
          Padding(
            child: Icon(Icons.swap_horiz),
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 2),
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Padding(
                  child: Text(toCurrency ?? "Tap to select"),
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                ),
              ),
            ),
            onTap: () {
              _navigateAndGetToCurrency(context);
            },
          ),
          ElevatedButton(
              onPressed: enableFetch ? () => _onConvertPress() : null,
              child: Text("Converter")),
          Center(
            child: Text(conversion ?? ""),
          )
        ],
      ),
    );
  }
}

class CurrenciesRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CurrenciesRouteState();
}

class _CurrenciesRouteState extends State<CurrenciesRoute> {
  var currencies = {
    "AED":"United Arab Emirates Dirham",
    "AFN":"Afghan Afghani",
    "ALL":"Albanian Lek",
    "AMD":"Armenian Dram",
    "ANG":"Netherlands Antillean Guilder",
    "AOA":"Angolan Kwanza",
    "ARS":"Argentine Peso",
    "AUD":"Australian Dollar",
    "AWG":"Aruban Florin",
    "AZN":"Azerbaijani Manat",
    "BAM":"Bosnia-Herzegovina Convertible Mark",
    "BBD":"Barbadian Dollar",
    "BDT":"Bangladeshi Taka",
    "BGN":"Bulgarian Lev",
    "BHD":"Bahraini Dinar",
    "BIF":"Burundian Franc",
    "BMD":"Bermudan Dollar",
    "BND":"Brunei Dollar",
    "BOB":"Bolivian Boliviano",
    "BRL":"Brazilian Real",
    "BSD":"Bahamian Dollar",
    "BTC":"Bitcoin",
    "BTN":"Bhutanese Ngultrum",
    "BWP":"Botswanan Pula",
    "BYR":"Belarusian Ruble",
    "BZD":"Belize Dollar",
    "CAD":"Canadian Dollar",
    "CDF":"Congolese Franc",
    "CHF":"Swiss Franc",
    "CLF":"Chilean Unit of Account (UF)",
    "CLP":"Chilean Peso",
    "CNY":"Chinese Yuan",
    "COP":"Colombian Peso",
    "CRC":"Costa Rican Colón",
    "CUC":"Cuban Convertible Peso",
    "CUP":"Cuban Peso",
    "CVE":"Cape Verdean Escudo",
    "CZK":"Czech Republic Koruna",
    "DJF":"Djiboutian Franc",
    "DKK":"Danish Krone",
    "DOP":"Dominican Peso",
    "DZD":"Algerian Dinar",
    "EGP":"Egyptian Pound",
    "ERN":"Eritrean Nakfa",
    "ETB":"Ethiopian Birr",
    "EUR":"Euro",
    "FJD":"Fijian Dollar",
    "FKP":"Falkland Islands Pound",
    "GBP":"British Pound Sterling",
    "GEL":"Georgian Lari",
    "GGP":"Guernsey Pound",
    "GHS":"Ghanaian Cedi",
    "GIP":"Gibraltar Pound",
    "GMD":"Gambian Dalasi",
    "GNF":"Guinean Franc",
    "GTQ":"Guatemalan Quetzal",
    "GYD":"Guyanaese Dollar",
    "HKD":"Hong Kong Dollar",
    "HNL":"Honduran Lempira",
    "HRK":"Croatian Kuna",
    "HTG":"Haitian Gourde",
    "HUF":"Hungarian Forint",
    "IDR":"Indonesian Rupiah",
    "ILS":"Israeli New Sheqel",
    "IMP":"Manx pound",
    "INR":"Indian Rupee",
    "IQD":"Iraqi Dinar",
    "IRR":"Iranian Rial",
    "ISK":"Icelandic Króna",
    "JEP":"Jersey Pound",
    "JMD":"Jamaican Dollar",
    "JOD":"Jordanian Dinar",
    "JPY":"Japanese Yen",
    "KES":"Kenyan Shilling",
    "KGS":"Kyrgystani Som",
    "KHR":"Cambodian Riel",
    "KMF":"Comorian Franc",
    "KPW":"North Korean Won",
    "KRW":"South Korean Won",
    "KWD":"Kuwaiti Dinar",
    "KYD":"Cayman Islands Dollar",
    "KZT":"Kazakhstani Tenge",
    "LAK":"Laotian Kip",
    "LBP":"Lebanese Pound",
    "LKR":"Sri Lankan Rupee",
    "LRD":"Liberian Dollar",
    "LSL":"Lesotho Loti",
    "LTL":"Lithuanian Litas",
    "LVL":"Latvian Lats",
    "LYD":"Libyan Dinar",
    "MAD":"Moroccan Dirham",
    "MDL":"Moldovan Leu",
    "MGA":"Malagasy Ariary",
    "MKD":"Macedonian Denar",
    "MMK":"Myanma Kyat",
    "MNT":"Mongolian Tugrik",
    "MOP":"Macanese Pataca",
    "MRO":"Mauritanian Ouguiya",
    "MUR":"Mauritian Rupee",
    "MVR":"Maldivian Rufiyaa",
    "MWK":"Malawian Kwacha",
    "MXN":"Mexican Peso",
    "MYR":"Malaysian Ringgit",
    "MZN":"Mozambican Metical",
    "NAD":"Namibian Dollar",
    "NGN":"Nigerian Naira",
    "NIO":"Nicaraguan Córdoba",
    "NOK":"Norwegian Krone",
    "NPR":"Nepalese Rupee",
    "NZD":"New Zealand Dollar",
    "OMR":"Omani Rial",
    "PAB":"Panamanian Balboa",
    "PEN":"Peruvian Nuevo Sol",
    "PGK":"Papua New Guinean Kina",
    "PHP":"Philippine Peso",
    "PKR":"Pakistani Rupee",
    "PLN":"Polish Zloty",
    "PYG":"Paraguayan Guarani",
    "QAR":"Qatari Rial",
    "RON":"Romanian Leu",
    "RSD":"Serbian Dinar",
    "RUB":"Russian Ruble",
    "RWF":"Rwandan Franc",
    "SAR":"Saudi Riyal",
    "SBD":"Solomon Islands Dollar",
    "SCR":"Seychellois Rupee",
    "SDG":"Sudanese Pound",
    "SEK":"Swedish Krona",
    "SGD":"Singapore Dollar",
    "SHP":"Saint Helena Pound",
    "SLL":"Sierra Leonean Leone",
    "SOS":"Somali Shilling",
    "SRD":"Surinamese Dollar",
    "STD":"São Tomé and Príncipe Dobra",
    "SVC":"Salvadoran Colón",
    "SYP":"Syrian Pound",
    "SZL":"Swazi Lilangeni",
    "THB":"Thai Baht",
    "TJS":"Tajikistani Somoni",
    "TMT":"Turkmenistani Manat",
    "TND":"Tunisian Dinar",
    "TOP":"Tongan Paʻanga",
    "TRY":"Turkish Lira",
    "TTD":"Trinidad and Tobago Dollar",
    "TWD":"New Taiwan Dollar",
    "TZS":"Tanzanian Shilling",
    "UAH":"Ukrainian Hryvnia",
    "UGX":"Ugandan Shilling",
    "USD":"United States Dollar",
    "UYU":"Uruguayan Peso",
    "UZS":"Uzbekistan Som",
    "VEF":"Venezuelan Bolívar Fuerte",
    "VND":"Vietnamese Dong",
    "VUV":"Vanuatu Vatu",
    "WST":"Samoan Tala",
    "XAF":"CFA Franc BEAC",
    "XAG":"Silver (troy ounce)",
    "XAU":"Gold (troy ounce)",
    "XCD":"East Caribbean Dollar",
    "XDR":"Special Drawing Rights",
    "XOF":"CFA Franc BCEAO",
    "XPF":"CFP Franc",
    "YER":"Yemeni Rial",
    "ZAR":"South African Rand",
    "ZMK":"Zambian Kwacha (pre-2013)",
    "ZMW":"Zambian Kwacha",
    "ZWL":"Zimbabwean Dollar",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a currency")),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final key = currencies.keys.toList()[index];
            return ListTile(
                title: Text(key),
                subtitle: Text(currencies[key]),
                onTap: () {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text(index.toString())));
                  Navigator.pop(context, key);
                },
            );
          },
          separatorBuilder: (context, index) => Divider(color: Colors.black, ),
          itemCount: currencies.length
      )

      /*ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final item = currencies[index];

          return ListTile(
            title: Text(item)
          );
        },
      )*/
      ,
    );
  }
}
