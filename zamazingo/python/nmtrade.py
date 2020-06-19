def margin_p(k = 10000, m = 5, ls = 14):
	print("Possible margin loss, calculated per cent")

	print("\n        Capital: " + str(k))
	print("         Margin: " + str(m) + " %")
	print("    Loss streak: " + str(ls) + " tries")

	am = int((k * ( m / 100 )) * 100) / 100
	a = int((k * ( m / 100 ) ) / ls)
	print("\nAbsolute margin: " + str(am))

	print("\nMaximum loss should be at: " + str(a))
	return a

def margin_a(k = 12000, m = 1000, ls= 14):
	print("Possible margin loss by given maximum margin")

	print("\n        Capital: " + str(k))
	print("Absolute margin: " + str(m))
	print("    Loss streak: " + str(ls) + " tries")

	pm = int(((m / k) * 100) * 100) / 100
	a = int(m / ls)
	print("\nMax margin per capital: " + str(pm) + " %")

	print("\nMaximum loss should be at: " + str(a))
	return a


