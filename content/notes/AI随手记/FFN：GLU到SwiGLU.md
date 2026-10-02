传统Transformer：记 $k_i$ 为 $W_1$ 的第 $i$ 行，$v_i$ 为 $W_2$ 的第 $i$ 列，它们都是 $\mathbb R^d$ 里的向量。那么FFN是

$$\mathrm{FFN}(x)=W_2\,\sigma(W_1x)=\sum_{i=1}^{d_\text{ff}}\sigma(k_i^\top x)\,v_i.$$
$\sigma$ 是激活函数，$W_1$ 是 $4d \times d$ 维，$W_2$ 是 $d \times 4d$ 维数