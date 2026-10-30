import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_database_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../domain/entities/employee.dart';

typedef _VMap = Map<String, Object?>;

class EmployeeVoucherPage extends ConsumerStatefulWidget {
  final EmployeeEntity employee;
  const EmployeeVoucherPage({super.key, required this.employee});
  @override
  ConsumerState<EmployeeVoucherPage> createState() => _EmployeeVoucherPageState();
}
class _EmployeeVoucherPageState extends ConsumerState<EmployeeVoucherPage> {
  Future<List<_VMap>> _load() async {
    final db=ref.read(appDatabaseProvider); await db.ensureEmployeeVouchersTable();
    final rows=await db.customSelect('SELECT id,date,amount_centavos FROM employee_vouchers WHERE employee_id=? ORDER BY date DESC,created_at DESC', variables:[Variable<String>(widget.employee.id)]).get();
    return rows.map((r)=>{'id':r.read<String>('id'),'date':r.read<String>('date'),'amount':r.read<int>('amount_centavos')}).toList();
  }
  Future<void> _edit([_VMap? item]) async {
    final existingDate = item?['date'] as String?;
    final date=TextEditingController(text: existingDate == null ? _date(DateTime.now()) : _date(DateTime.parse(existingDate).toLocal()));
    final amount=TextEditingController(text:item==null?'':_inputMoney(item['amount'] as int));
    var closing=false;
    void submit(BuildContext c){if(closing||!Form.of(c).validate())return;closing=true;FocusManager.instance.primaryFocus?.unfocus();WidgetsBinding.instance.addPostFrameCallback((_){if(c.mounted)Navigator.pop(c,true);});}
    final saved=await showModalBottomSheet<bool>(context:context,isScrollControlled:true,showDragHandle:true,builder:(ctx)=>Padding(padding:EdgeInsets.fromLTRB(20,12,20,MediaQuery.of(ctx).viewInsets.bottom+24),child:Form(child:Builder(builder:(c)=>Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[Text(item==null?'Registrar vale':'Editar vale',style:Theme.of(c).textTheme.titleLarge),const SizedBox(height:16),TextFormField(controller:date,keyboardType:TextInputType.datetime,textInputAction:TextInputAction.next,onFieldSubmitted:(_)=>submit(c),inputFormatters:[_DateFormatter()],decoration:const InputDecoration(labelText:'Data',hintText:'DD/MM/AAAA'),validator:(v)=>_parse(v??'')==null?'Informe uma data válida.':null),const SizedBox(height:12),TextFormField(controller:amount,keyboardType:const TextInputType.numberWithOptions(decimal:true),textInputAction:TextInputAction.done,onFieldSubmitted:(_)=>submit(c),inputFormatters:[_MoneyFormatter()],decoration:const InputDecoration(labelText:'Valor',prefixText:'R\$ '),validator:(v)=>_cents(v??'')<=0?'Informe um valor maior que zero.':null),const SizedBox(height:20),FilledButton(onPressed:()=>submit(c),child:Text(item==null?'SALVAR':'ATUALIZAR'))])))));
    if(saved==true&&mounted){final db=ref.read(appDatabaseProvider);final d=_parse(date.text)!;final id=item?['id'] as String? ?? DateTime.now().microsecondsSinceEpoch.toString();await db.customStatement('INSERT OR REPLACE INTO employee_vouchers(id,employee_id,date,amount_centavos,created_at) VALUES(?,?,?,?,?)',[id,widget.employee.id,d.toIso8601String(),_cents(amount.text),DateTime.now().toUtc().toIso8601String()]);if(mounted)setState((){});}
    Future.delayed(const Duration(milliseconds:300),(){date.dispose();amount.dispose();});
  }
  Future<void> _delete(String id) async {final yes=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Excluir vale?'),content:const Text('Essa ação não pode ser desfeita.'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('CANCELAR')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('EXCLUIR'))]));if(yes==true){await ref.read(appDatabaseProvider).customStatement('DELETE FROM employee_vouchers WHERE id=?',[id]);setState((){});}}
  @override Widget build(BuildContext context)=>AppFormLayout(title:'Histórico de vales',appBarColor:AppMenuColors.employees,child:FutureBuilder<List<_VMap>>(future:_load(),builder:(context,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());if(s.data!.isEmpty)return Center(child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('Nenhum vale registrado.'),const SizedBox(height:12),FilledButton.icon(onPressed:()=>_edit(),icon:const Icon(Icons.add),label:const Text('REGISTRAR VALE'))]));return Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[Text('Vales de ${widget.employee.nome}',style:Theme.of(context).textTheme.titleMedium),const SizedBox(height:12),...s.data!.map((v)=>Card(child:ListTile(onTap:()=>_edit(v),leading:const Icon(Icons.receipt_long_outlined),title:Text(_money(v['amount'] as int)),subtitle:Text(_date(DateTime.parse(v['date'] as String).toLocal())),trailing:IconButton(tooltip:'Excluir vale',icon:const Icon(Icons.delete_outline,color:Colors.red),onPressed:()=>_delete(v['id'] as String))))),const SizedBox(height:12),FilledButton.icon(onPressed:()=>_edit(),icon:const Icon(Icons.add),label:const Text('REGISTRAR VALE'))]);}));
}
DateTime? _parse(String s){final m=RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(s);if(m==null)return null;final d=DateTime(int.parse(m[3]!),int.parse(m[2]!),int.parse(m[1]!));return d.day==int.parse(m[1]!)&&d.month==int.parse(m[2]!)&&d.year==int.parse(m[3]!)?d:null;}
String _date(DateTime d)=>'${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
int _cents(String s){final digits=s.replaceAll(RegExp(r'\D'),'');return int.tryParse(digits)??0;}
String _money(int c)=>'R\$ ${(c~/100).toString()},${(c%100).toString().padLeft(2,'0')}';
String _inputMoney(int c)=>'${c~/100},${(c%100).toString().padLeft(2,'0')}';
class _DateFormatter extends TextInputFormatter{ @override TextEditingValue formatEditUpdate(TextEditingValue o,TextEditingValue n){final x=n.text.replaceAll(RegExp(r'\D'),'');final b=StringBuffer();for(var i=0;i < x.length&&i < 8;i++){if(i==2||i==4)b.write('/');b.write(x[i]);}return TextEditingValue(text:b.toString(),selection:TextSelection.collapsed(offset:b.length));}}
class _MoneyFormatter extends TextInputFormatter{ @override TextEditingValue formatEditUpdate(TextEditingValue o,TextEditingValue n){final d=n.text.replaceAll(RegExp(r'\D'),'');if(d.isEmpty)return const TextEditingValue();final c=int.tryParse(d)??0;final t='${c~/100},${(c%100).toString().padLeft(2,'0')}';return TextEditingValue(text:t,selection:TextSelection.collapsed(offset:t.length));}}