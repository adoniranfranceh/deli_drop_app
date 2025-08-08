export function FloatToMoney(float) {
  const decimalPlaces = 2;
  return `R$ ${(float / 100).toFixed(decimalPlaces).replace('.', ',')}`
}
