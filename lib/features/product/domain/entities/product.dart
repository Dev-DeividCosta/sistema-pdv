class ProductEntity {
  final String id;
  final String? codigoBarras;
  final String nomeProduto;
  final double precoCusto;
  final double precoVenda;
  final int quantidadeEstoque;
  final bool ativo;
  final String? descricao;
  final int estoqueMinimo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    this.codigoBarras,
    required this.nomeProduto,
    required this.precoCusto,
    required this.precoVenda,
    this.quantidadeEstoque = 0,
    this.ativo = true,
    this.descricao,
    this.estoqueMinimo = 0,
    required this.createdAt,
    required this.updatedAt,
  });
}
