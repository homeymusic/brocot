test_that('true is true', {
  expect_true(T)
})
test_that('coprimer works', {
  r = coprimer::nearby_coprime(sqrt(2), 0.008, 0.002)
  expect_equal(r$num, 58)
  expect_equal(r$den, 41)
})
test_that('coprimer works', {
  r = coprimer::nearby_coprime(sqrt(2), 0.002, 0.008)
  expect_equal(r$num, 41)
  expect_equal(r$den, 29)
})
