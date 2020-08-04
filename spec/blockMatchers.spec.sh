@spec.blockMatcher.matcher_not_found() {
  refute run expect { hello } toDoSomethingNobodyDefined
  assert [ "$STDOUT" = "" ]
  if [[ "$STDERR" != *"expect.matcher.toDoSomethingNobodyDefined: command not found" ]]
  then
    echo "STDERR did not include the expected text, actual: $STDERR" >&2
    return 1
  fi
}

@spec.blockMatcher.error_if_braces_not_closed() {
  refute run expect { hello there
  assert [ "$STDOUT" = "" ]
  assert [ "$STDERR" = "Expected block closing braces but found none" ]

  refute run expect {{ hello there
  assert [ "$STDOUT" = "" ]
  assert [ "$STDERR" = "Expected block closing braces but found none" ]

  refute run expect [[[ hello there
  assert [ "$STDOUT" = "" ]
  assert [ "$STDERR" = "Expected block closing braces but found none" ]
}

expect.matcher.toDoSomething() {
  block="${BLOCK[@]}"
  blockType="$BLOCK_TYPE"
  not="$NOT"
  name="$MATCHER_NAME"
  fn="$MATCHER_FUNCTION"
}

@spec.blockMatcher.block_available_to_matcher_as_BLOCK() {
  local block=""
  assert [ "$block" = "" ]

  expect { hello I am in the block } toDoSomething

  assert [ "$block" = "hello I am in the block" ]
}

@spec.blockMatcher.type_available_to_matcher_as_BLOCK_TYPE() {
  local blockType=""
  assert [ "$blockType" = "" ]

  expect { hello I am in the block } toDoSomething

  assert [ "$blockType" = "{" ]

  expect {{{ hello I am in the block }}} toDoSomething

  assert [ "$blockType" = "{{{" ]
}

@spec.blockMatcher.NOT_is_available() {
  local not=""
  assert [ -z "$not" ]

  expect { hello I am in the block } toDoSomething

  assert [ -z "$not" ]

  expect { hello I am in the block } not toDoSomething

  assert [ -n "$not" ]
}

@spec.blockMatcher.MATCHER_NAME_is_available() {
  local name=""
  assert [ -z "$name" ]

  expect { hello I am in the block } toDoSomething

  assert [ "$name" = "toDoSomething" ]
}

@spec.blockMatcher.MATCHER_FUNCTION_is_available() {
  local fn=""
  assert [ -z "$fn" ]

  expect { hello I am in the block } toDoSomething

  assert [ "$fn" = "expect.matcher.toDoSomething" ]
}

@spec.blockMatcher.can_customize_block_start_and_end_symbols() {
  local block=""
  local blockType=""
  assert [ "$block" = "" ]
  assert [ "$blockType" = "" ]

  EXPECT_BLOCK_START_PATTERN='@@'
  EXPECT_BLOCK_END_PATTERN='@@'

  expect @@ Haha this works @@ toDoSomething

  assert [ "$block" = "Haha this works" ]
  assert [ "$blockType" = "@@" ]
}