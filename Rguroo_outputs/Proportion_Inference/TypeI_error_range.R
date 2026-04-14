# x-values
p1 <- seq(0, 0.70, by = 0.01)
p2 <- seq(0.35, 1.00, by = 0.01)

# Panel (a)
y16 <- pbinom(15, 20, p1, lower.tail = FALSE)
y17 <- pbinom(16, 20, p1, lower.tail = FALSE)
y18 <- pbinom(17, 20, p1, lower.tail = FALSE)

# Panel (b)
z11 <- pbinom(11, 50, p2)
z12 <- pbinom(12, 50, p2)
z13 <- pbinom(13, 50, p2)

# Okabe-Ito colors (colorblind-friendly)
cols <- c("#D55E00", "#009E73", "#0072B2")

par(mfrow = c(1, 2), mar = c(5, 5, 4, 2) + 0.1)

# -------------------------
# (a)
# -------------------------
plot(p1, y16, type = "l", lwd = 2, lty = 1, col = cols[1],
     xlim = c(0, 0.8), ylim = c(0, 0.25),
     xlab = expression(pi),
     ylab = "Probability of Type I error",
     main = "(a) The YouTube Example")

lines(p1, y17, lwd = 2, lty = 2, col = cols[2])
lines(p1, y18, lwd = 2, lty = 3, col = cols[3])
abline(v = 0.70, col = "gray40", lwd = 1, lty = 3)
text(
  x = 0.72,
  y = 0.11,
  labels = expression("Boundary of " * H[0] * ":" ~ pi == 0.70),
  srt = 90,
  pos = 4,
  col = "gray30",
  cex = 0.9
)

abline(h = 0.05, col = "red", lwd = 1.5, lty = 2)

legend("topleft",
       legend = c(
         expression(P(X >= 16 ~ "|" ~ pi)),
         expression(P(X >= 17 ~ "|" ~ pi)),
         expression(P(X >= 18 ~ "|" ~ pi))
       ),
       col = cols, lty = c(1, 2, 3), lwd = 2, bty = "n")

# -------------------------
# (b)
# -------------------------
plot(p2, z11, type = "l", lwd = 2, lty = 1, col = cols[1],
     xlim = c(0.25, 1), ylim = c(0, 0.25),
     xlab = expression(pi),
     ylab = "Probability of Type I error",
     main = "(b) The Physical Inactivity Example")

lines(p2, z12, lwd = 2, lty = 2, col = cols[2])
lines(p2, z13, lwd = 2, lty = 3, col = cols[3])

abline(h = 0.05, col = "red", lwd = 1.5, lty = 2)
abline(v = 0.35, col = "gray40", lwd = 1, lty = 3)
text(
  x = 0.345,
  y = 0.23,
  labels = expression("Boundary of " * H[0] * ":" ~ pi == 0.35),
  srt = 90,
  pos = 2,
  col = "gray30",
  cex = 0.9
)

legend("topright",
       legend = c(
         expression(P(X <= 11 ~ "|" ~ pi)),
         expression(P(X <= 12 ~ "|" ~ pi)),
         expression(P(X <= 13 ~ "|" ~ pi))
       ),
       col = cols, lty = c(1, 2, 3), lwd = 2, bty = "n")