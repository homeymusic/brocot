test_that('true is true', {
  expect_true(T)
})
test_that('coprimer works', {
  r = coprimer::stern_brocot(sqrt(2), 0.08, 0.08)
  expect_equal(r$num, 7)
  expect_equal(r$den, 5)
})
