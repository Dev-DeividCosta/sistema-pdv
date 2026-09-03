import 'package:flutter/material.dart';
import '../../../product/presentation/pages/product_menu_page.dart';
import '../../../../core/models/app_menu_item.dart'; 
import '../../../../core/constants/app_colors.dart';
import '../../../customer/presentation/pages/customer_menu_page.dart';
import '../../../itinerary/presentation/pages/itinerary_cities_page.dart';
import '../../../city/presentation/pages/city_menu_page.dart';
import '../../../sale/presentation/pages/sale_menu_page.dart';
import '../../../employee/presentation/pages/employee_menu_page.dart';
import '../../../payment_method/presentation/pages/payment_method_menu_page.dart';
import '../../../company/presentation/pages/company_form_page.dart';
import '../../../../core/widgets/forms/form_mode.dart';

abstract class DashboardBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context); 
}

class DashboardBuilderImpl implements DashboardBuilder {
  @override
  List<AppMenuItem> getMenuItems(BuildContext context) { 
    return [
      AppMenuItem(
        icon: Icons.group,
        title: 'Clientes',
        color: AppMenuColors.customer,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerMenuPage(),
            ),
          );
        },
      ),
      AppMenuItem(
        icon: Icons.route,
        title: 'Viagens',
        color: const Color(0xFF00ACC1),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItineraryCitiesPage(), 
            ),
          );
        },
      ),
      AppMenuItem(
        icon: Icons.badge,
        title: 'Funcionários',
        color: AppMenuColors.employees,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeMenuPage()),
        ),
      ),
      AppMenuItem(
        icon: Icons.inventory_2,
        title: 'Produtos',
        color: const Color(0xFF2980B9),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductMenuPage())),
      ),
      AppMenuItem(
        icon: Icons.point_of_sale,
        title: 'Vendas',
        color: AppMenuColors.sale,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SaleMenuPage()),
        ),
      ),
      AppMenuItem(
        icon: Icons.map,
        title: 'Cidades',
        color: AppMenuColors.city,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CityMenuPage(),
            ),
          );
        },
      ),
      AppMenuItem(
        icon: Icons.credit_card,
        title: 'Formas de Pagamento',
        color: AppMenuColors.paymentMethods,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodMenuPage()),
        ),
      ),
                  AppMenuItem(
        icon: Icons.business,
        title: 'Dados empresariais',
        color: AppMenuColors.company,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CompanyFormPage(mode: AppFormMode.view),
          ),
        ),
      ),
      // AppMenuItem(
      //   icon: Icons.straighten,
      //   title: 'Medidas',
      //   color: const Color(0xFF008080),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.category,
      //   title: 'Categorias de\nProdutos',
      //   color: const Color(0xFF8E44AD),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.request_quote,
      //   title: 'Receber',
      //   color: const Color(0xFF27AE60),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.badge,
      //   title: 'Funcionários',
      //   color: const Color(0xFFE74C3C),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.account_balance_wallet,
      //   title: 'Despesas',
      //   color: const Color(0xFF5D6D7E),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.calendar_month,
      //   title: 'Gerenciar\nParcelamentos',
      //   color: const Color(0xFF5C6BC0),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.remove_shopping_cart,
      //   title: 'Baixar Estoque\nManualmente',
      //   color: const Color(0xFF1976D2),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.person_search,
      //   title: 'Quem\nComprou?',
      //   color: const Color(0xFF90A4AE),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.request_page,
      //   title: 'Meus\nOrçamentos',
      //   color: const Color(0xFF9575CD),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.menu_book,
      //   title: 'Galeria de\nObservações',
      //   color: const Color(0xFFF5B041),
      //   onTap: () {},
      // ), */
      // /* AppMenuItem(
      //   icon: Icons.assignment_return,
      //   title: 'Reposição por\nFornecedor',
      //   color: const Color(0xFF2E86C1),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.people_alt,
      //   title: 'Clientes X Produtos',
      //   color: const Color(0xFF8E44AD),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.bar_chart,
      //   title: 'Gerador de\nGráficos',
      //   color: const Color(0xFFE74C3C),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.grid_view,
      //   title: 'Produtos Vendidos\nMês a Mês',
      //   color: const Color(0xFF3498DB),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.calculate,
      //   title: 'Resumo\nAnual',
      //   color: const Color(0xFF7F8C8D),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.account_balance_wallet_outlined,
      //   title: 'Painel de\nCobranças',
      //   color: const Color(0xFFF39C12),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.payments,
      //   title: 'Contas\nA Pagar/Pagas',
      //   color: const Color(0xFF27AE60),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.groups,
      //   title: 'Vendas por\nClientes',
      //   color: const Color(0xFF2980B9),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.event_note,
      //   title: 'Vendas de\num Período',
      //   color: const Color(0xFF27AE60),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.receipt_long,
      //   title: 'Extrato para\nClientes',
      //   color: const Color(0xFF3498DB),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.shopping_cart,
      //   title: 'Todas as Vendas\nRealizadas',
      //   color: const Color(0xFF8BC34A),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.monetization_on,
      //   title: 'Lucros Sobre\nas Vendas',
      //   color: const Color(0xFFF39C12),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.price_change,
      //   title: 'Clientes X\nValor a receber',
      //   color: const Color(0xFF5D6D7E),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.menu_book,
      //   title: 'Pgtos Recebidos\nX Despesas',
      //   color: const Color(0xFF3F51B5),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.query_stats,
      //   title: 'Lucro - Despesas\n(Por período)',
      //   color: const Color(0xFFD32F2F),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.savings,
      //   title: 'Pagamentos\nRecebidos',
      //   color: const Color(0xFFF1C40F),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.emoji_events,
      //   title: 'Produtos\nMais Vendidos',
      //   color: const Color(0xFFE67E22),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.battery_alert,
      //   title: 'Produtos com\nEstoque Baixo',
      //   color: const Color(0xFF607D8B),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.account_tree,
      //   title: 'Produtos Separados\npor Categoria',
      //   color: const Color(0xFF2196F3),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.inventory_2,
      //   title: 'Produtos Separados\npor Fornecedor',
      //   color: const Color(0xFF0288D1),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.credit_card,
      //   title: 'Pagamentos x\nForma de Pagto',
      //   color: const Color(0xFF8E44AD),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.person,
      //   title: 'Vendas por\nFuncionário',
      //   color: const Color(0xFF1976D2),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.paid,
      //   title: 'Pagamentos por\nFuncionários',
      //   color: const Color(0xFFF39C12),
      //   onTap: () {},
      // ),
      // AppMenuItem(
      //   icon: Icons.handshake,
      //   title: 'Produtos e Serviços\nPor Período',
      //   color: const Color(0xFF009688),
      //   onTap: () {},
      // ), */
    ];
  }
}