import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../../../../core/widgets/sale_status_tag.dart';
import '../../../sale/domain/entities/sale_status.dart';
import '../../../sale/presentation/pages/sale_detail_page.dart';
import '../../domain/entities/financial_entry.dart';
import '../../domain/entities/financial_query.dart';
import '../providers/financial_provider.dart';

class FinancialResultsPage extends ConsumerStatefulWidget {
  final FinancialQuery query;
  final String cityLabel;
  final String employeeLabel;

  const FinancialResultsPage({
    super.key,
    required this.query,
    required this.cityLabel,
    required this.employeeLabel,
  });

  @override
  ConsumerState<FinancialResultsPage> createState() => _FinancialResultsPageState();
}

class _FinancialResultsPageState extends ConsumerState<FinancialResultsPage> {
  Timer? _refreshTimer;

  void _safeInvalidateReport() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
      if (isCurrentRoute) {
        ref.invalidate(financialReportProvider(widget.query));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _safeInvalidateReport();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(financialReportProvider(widget.query));
    final colors = Theme.of(context).colorScheme;
    final selectedStatuses = widget.query.statuses
        .where((status) => status != 'voucher')
        .map(SaleStatus.fromValue)
        .toList();

    return Scaffold(
      extendBody: true,
      appBar: AppAppBar(
        title: 'Resultado financeiro',
        backgroundColor: AppMenuColors.company,
      ),
      bottomNavigationBar: const AppNavigationBar(),
      body: RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(financialReportProvider(widget.query).future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 132),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Relatório financeiro',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Confira o total e os lançamentos encontrados.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _AppliedFiltersCard(
                          cityLabel: widget.cityLabel,
                          employeeLabel: widget.employeeLabel,
                          query: widget.query,
                          statuses: selectedStatuses,
                        ),
                        const SizedBox(height: 18),
                        report.when(
                          loading: () => const _LoadingResults(),
                          error: (error, _) => _ErrorResults(
                            onRetry: () => ref.invalidate(financialReportProvider(widget.query)),
                          ),
                          data: (data) {
                            final sales = data.groups
                                .expand((group) => group.sales)
                                .toList(growable: false);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _TotalCard(
                                  totalCentavos: data.totalCentavos,
                                  netTotalCentavos: data.netTotalCentavos,
                                  saleCount: data.saleCount,
                                  statusTotals: data.statusTotals,
                                  sales: sales,
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Lançamentos por dia',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '${data.groups.length} ${data.groups.length == 1 ? 'dia' : 'dias'}',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (data.groups.isEmpty)
                                  const _EmptyResults()
                                else
                                  ...data.groups.map(
                                    (group) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _DaySalesSection(group: group),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                const _ResultsFootnote(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppliedFiltersCard extends StatelessWidget {
  final String cityLabel;
  final String employeeLabel;
  final FinancialQuery query;
  final List<SaleStatus> statuses;

  const _AppliedFiltersCard({
    required this.cityLabel,
    required this.employeeLabel,
    required this.query,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 17, color: colors.primary),
              const SizedBox(width: 7),
              Text(
                'FILTROS APLICADOS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _FilterLine(icon: Icons.location_on_outlined, text: cityLabel),
          const SizedBox(height: 7),
          _FilterLine(icon: Icons.person_outline, text: employeeLabel),
          const SizedBox(height: 7),
          _FilterLine(
            icon: Icons.date_range_outlined,
            text: '${_formatDate(query.startDate)} – ${_formatDate(query.endDate)}',
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 2,
            children: [
              ...statuses.map(
                (status) => Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(status.label),
                  labelStyle: TextStyle(
                    fontSize: 11,
                    color: status.color,
                    fontWeight: FontWeight.w700,
                  ),
                  avatar: Icon(Icons.circle, size: 8, color: status.color),
                  padding: EdgeInsets.zero,
                  backgroundColor: status.color.withValues(alpha: 0.10),
                  side: BorderSide(color: status.color.withValues(alpha: 0.25)),
                ),
              ),
              if (query.statuses.contains('voucher'))
                const Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('Vales'),
                  avatar: Icon(Icons.circle, size: 8, color: Color(0xFFCE93D8)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FilterLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
}

class _TotalCard extends StatelessWidget {
  final int totalCentavos;
  final int netTotalCentavos;
  final int saleCount;
  final Map<String, FinancialStatusTotal> statusTotals;
  final List<FinancialEntry> sales;

  const _TotalCard({
    required this.totalCentavos,
    required this.netTotalCentavos,
    required this.saleCount,
    required this.statusTotals,
    required this.sales,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = <({String label, int amount, Color color, String description})>[];
    var paidAmount = 0;
    var pendingAmount = 0;
    var hasPaymentStatus = false;
    var hasPendingSales = false;
    final completedSales = sales.where(
      (sale) => sale.saleStatus == SaleStatus.paid.value && sale.pendingCentavos == 0,
    );
    final partialSales = sales.where(
      (sale) =>
          sale.pendingCentavos > 0 &&
          sale.paidCentavos > 0 &&
          sale.saleStatus != SaleStatus.cancelled.value &&
          sale.saleStatus != SaleStatus.returned.value,
    );
    final completedAmount = completedSales.fold<int>(0, (sum, sale) => sum + sale.paidCentavos);
    final partialAmount = partialSales.fold<int>(0, (sum, sale) => sum + sale.paidCentavos);

    for (final entry in statusTotals.entries) {
      final status = SaleStatus.fromValue(entry.key);
      final count = entry.value.saleCount;
      if (entry.key == 'voucher') {
        statuses.add((
          label: 'Vales / retiradas',
          amount: entry.value.amountCentavos.abs(),
          color: const Color(0xFFCE93D8),
          description: '${entry.value.saleCount} ${entry.value.saleCount == 1 ? 'vale' : 'vales'}',
        ));
        continue;
      }
      if (status == SaleStatus.paid || status == SaleStatus.pending) {
        hasPaymentStatus = true;
        paidAmount += entry.value.paidCentavos;
        pendingAmount += entry.value.pendingCentavos;
        hasPendingSales = hasPendingSales || status == SaleStatus.pending;
        continue;
      }
      statuses.add((
        label: status.label,
        amount: entry.value.amountCentavos,
        color: status.color,
        description: '$count ${count == 1 ? 'venda' : 'vendas'}',
      ));
    }

    if (hasPaymentStatus) {
      String paidDescription =
          '${completedSales.length} concluído${completedSales.length == 1 ? '' : 's'} (${_money(completedAmount)})';
      if (partialSales.isNotEmpty) {
        paidDescription +=
            ' · ${partialSales.length} ${partialSales.length == 1 ? 'parcial' : 'parciais'} (${_money(partialAmount)})';
      }

      statuses.add((
        label: SaleStatus.paid.label,
        amount: paidAmount,
        color: SaleStatus.paid.color,
        description: paidDescription,
      ));
      if (hasPendingSales || pendingAmount > 0) {
        statuses.add((
          label: SaleStatus.pending.label,
          amount: pendingAmount,
          color: SaleStatus.pending.color,
          description: 'saldo restante',
        ));
      }
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF087F5B), Color(0xFF075E48)],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF087F5B).withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text(
                'TOTAL BRUTO DE VENDAS',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _money(totalCentavos),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '$saleCount ${saleCount == 1 ? 'venda encontrada' : 'vendas encontradas'}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.white70),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'SALDO LÍQUIDO ESTIMADO',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                Text(
                  _money(netTotalCentavos),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          if (statuses.isNotEmpty) ...[
            const SizedBox(height: 17),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.white24, height: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Text(
                    'DETALHAMENTO POR STATUS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: Colors.white24, height: 1)),
              ],
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = statuses.length == 1 || constraints.maxWidth < 380 ? 1 : 2;
                final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
                var percentageUsed = 0.0;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: statuses.asMap().entries.map((indexedEntry) {
                    final entry = indexedEntry.value;
                    final amount = entry.amount;
                    final rawPercentage =
                        totalCentavos == 0 ? 0.0 : (amount / totalCentavos) * 100;
                    final remainingPercentage =
                        (100.0 - percentageUsed).clamp(0.0, 100.0).toDouble();
                    final percentage = indexedEntry.key == statuses.length - 1
                        ? remainingPercentage
                        : rawPercentage.clamp(0.0, remainingPercentage).toDouble();
                    final shownPercentage = double.parse(percentage.toStringAsFixed(2));
                    percentageUsed += shownPercentage;
                    final share = shownPercentage / 100;
                    return SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: entry.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    entry.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${shownPercentage.toStringAsFixed(2).replaceAll('.', ',')}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _money(amount),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              entry.description,
                              style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: share,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(alpha: 0.14),
                                valueColor: AlwaysStoppedAnimation<Color>(entry.color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(growable: false),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _DaySalesSection extends StatelessWidget {
  final FinancialGroup group;

  const _DaySalesSection({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final returnedAmount = group.sales
        .where((s) => s.saleStatus == SaleStatus.returned.value)
        .fold<int>(0, (sum, s) => sum + s.amountCentavos);
    final cancelledAmount = group.sales
        .where((s) => s.saleStatus == SaleStatus.cancelled.value)
        .fold<int>(0, (sum, s) => sum + s.amountCentavos);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group.label,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _DayMetricText(
                      label: '${group.saleCount} ${group.saleCount == 1 ? 'venda' : 'vendas'}',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    _DayMetricText(
                      label: 'Total: ${_money(group.amountCentavos)}',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    if (group.paidCentavos > 0)
                      _DayMetricText(
                        label: 'Quitado: ${_money(group.paidCentavos)}',
                        color: const Color(0xFF72D6A8),
                      ),
                    if (group.pendingCentavos > 0)
                      _DayMetricText(
                        label: 'Pendente: ${_money(group.pendingCentavos)}',
                        color: const Color(0xFFFFC857),
                      ),
                    if (returnedAmount > 0)
                      _DayMetricText(
                        label: 'Devolvido: ${_money(returnedAmount)}',
                        color: SaleStatus.returned.color,
                      ),
                    if (cancelledAmount > 0)
                      _DayMetricText(
                        label: 'Cancelado: ${_money(cancelledAmount)}',
                        color: SaleStatus.cancelled.color,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ...group.sales.map((sale) => _FinancialSaleCard(sale: sale)),
      ],
    );
  }
}

class _DayMetricText extends StatelessWidget {
  final String label;
  final Color? color;

  const _DayMetricText({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: effectiveColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: effectiveColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FinancialSaleCard extends StatelessWidget {
  final FinancialEntry sale;

  const _FinancialSaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    if (sale.saleStatus == 'voucher') {
      const color = Color(0xFFCE93D8);
      return Card(
        color: color.withValues(alpha: 0.10),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: const Icon(Icons.receipt_long_outlined, color: color),
          title: Text(
            'Vale de ${sale.customerName}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text('Retirada • ${_formatDateTime(sale.soldAt)}'),
          trailing: Text(
            _money(sale.amountCentavos.abs()),
            style: const TextStyle(fontWeight: FontWeight.w800, color: color),
          ),
        ),
      );
    }
    final status = SaleStatus.fromValue(sale.saleStatus);
    final itemNames = sale.itemsSummary.trim();
    final extraItems = sale.itemCount > 2 ? ' e mais ${sale.itemCount - 2}' : '';
    final shortId = sale.saleId.length <= 8
        ? sale.saleId
        : sale.saleId.substring(sale.saleId.length - 8);

    return Card(
      color: status.color.withValues(alpha: 0.10),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: status.color.withValues(alpha: 0.55)),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: sale.saleId.isEmpty
            ? null
            : () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => SaleDetailPage(saleId: sale.saleId),
                  ),
                ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppMenuColors.sale.withValues(alpha: 0.15),
                          child: const Icon(Icons.person, color: AppMenuColors.sale, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            sale.customerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total: ${_money(sale.amountCentavos)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _saleInfoChip(
                      Icons.calendar_today_outlined,
                      _formatDateTime(sale.soldAt),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _saleInfoChip(Icons.format_list_numbered, '${sale.installments}x'),
                ],
              ),
              if (status != SaleStatus.returned && sale.pendingCentavos > 0) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _PaymentAmountLine(
                        label: 'Quitado',
                        amountCentavos: sale.paidCentavos,
                        color: const Color(0xFF72D6A8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: _PaymentAmountLine(
                        label: 'Pendente',
                        amountCentavos: sale.pendingCentavos,
                        color: const Color(0xFFFFC857),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              const SizedBox(height: 12),
              _saleInfoChip(
                Icons.shopping_bag_outlined,
                itemNames.isEmpty ? 'Itens da venda' : '$itemNames$extraItems',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: Colors.white12, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#$shortId',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SaleStatusTag(status: sale.saleStatus, compact: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentAmountLine extends StatelessWidget {
  final String label;
  final int amountCentavos;
  final Color color;

  const _PaymentAmountLine({
    required this.label,
    required this.amountCentavos,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_outlined, size: 15, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              '$label: ${_money(amountCentavos)}',
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

Widget _saleInfoChip(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[300], fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

String _formatDateTime(DateTime value) =>
    '${_formatDate(value)} - ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

class _LoadingResults extends StatelessWidget {
  const _LoadingResults();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(top: 64),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 34, color: colors.onSurfaceVariant),
          const SizedBox(height: 10),
          Text(
            'Nenhuma venda encontrada',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Tente ajustar a cidade, as datas ou os status selecionados.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorResults extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorResults({required this.onRetry});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Não foi possível carregar o resultado.'),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      );
}

class _ResultsFootnote extends StatelessWidget {
  const _ResultsFootnote();

  @override
  Widget build(BuildContext context) => Text(
        'O total considera o valor registrado em cada venda dos status selecionados.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

String _money(int centavos) {
  final parts = (centavos / 100).toStringAsFixed(2).split('.');
  final integer = parts.first.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  return 'R\$ $integer,${parts.last}';
}