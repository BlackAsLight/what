(module
  (memory (export "memory") 1)

  (global $alloc_is_enabled (mut i32) (i32.const 1))
  (global $alloc (mut i32) (i32.const 256))
  (func $alloc (param $size i32) (result i32)
    (loop $loop (if
      (i32.gt_u
        (i32.add (global.get $alloc) (local.get $size))
        (i32.mul (memory.size) (i32.const 65536))
      )
    (then
      (memory.grow (i32.const 1))
      (br $loop)
    )))

    (;;) (global.get $alloc)
    (if (global.get $alloc_is_enabled) (then
      (global.set $alloc (i32.add (global.get $alloc) (local.get $size)))
    ))
  )

  (func $set_alloc (param $addr i32) (result)
    (global.set $alloc (local.get $addr))
  )

  (func $get_alloc (result i32)
    (;;) (global.get $alloc)
  )

  (func $enable_alloc (result)
    (global.set $alloc_is_enabled (i32.const 1))
  )

  (func $disable_alloc (result)
    (global.set $alloc_is_enabled (i32.const 0))
  )

  (data (i32.const 0)   "\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00")
  (data (i32.const 16)  "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 32)  "\01\00\00\00\00\00\00\00\00\00\04\02\00\03\00\05")
  (data (i32.const 48)  "\64\64\64\64\64\64\64\64\64\64\00\06\00\00\00\00")
  (data (i32.const 64)  "\00\65\65\65\65\65\65\65\65\65\65\65\65\65\65\65")
  (data (i32.const 80)  "\65\65\65\65\65\65\65\65\65\65\65\00\00\00\00\00")
  (data (i32.const 96)  "\00\65\65\65\65\65\65\65\65\65\65\65\65\65\65\65")
  (data (i32.const 112) "\65\65\65\65\65\65\65\65\65\65\65\00\00\00\00\00")
  (data (i32.const 128) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 144) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 160) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 176) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 192) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 208) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 224) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 240) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")

  (func $scan (param $size i32) (result i32 i32)
    ;; (has_error, addr)
    (local $i i32)
    (local $o i32)
    (local $char i32)

    (;;) (local.tee $i (i32.const 256))
    (;;) (local.tee $size (i32.add (;;) (local.get $size)))
    (local.set $o (;;))

    (loop $next (if (i32.lt_u (local.get $i) (local.get $size)) (then
      (;;) (local.tee $char (i32.load8_u (i32.load8_u (local.get $i))))
      (if (i32.eqz (;;)) (then
        (return (i32.const 1) (local.get $i))
      ))
      (if (i32.eq (local.get $char) (i32.const 1)) (then
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $next)
      ))
      (if (i32.ge_u (local.get $char) (i32.const 2)) (then
        (if (i32.lt_u (local.get $char) (i32.const 100)) (then
          (i32.store8 (local.get $o) (local.get $char))
          (;;) (local.tee $o (i32.add (local.get $o) (i32.const 1)))
          (;;) (local.get $i)
          (i32.store (;;) (;;))
          (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (i32.store (;;) (;;))
          (local.set $o (i32.add (local.get $o) (i32.const 4)))
          (br $next)
        ))
      ))
      (if (i32.eq (local.get $char) (i32.const 100)) (then
        (i32.store8 (local.get $o) (local.get $char))
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 1)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (loop $x
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (br_if $x (i32.eq (i32.load8_u (i32.load8_u (;;))) (i32.const 100)))
        )
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (local.set $o (i32.add (local.get $o) (i32.const 4)))
        (br $next)
      ))
      (if (i32.eq (local.get $char) (i32.const 101)) (then
        (;;) (local.get $o) ;; $keyword

        (i32.store8 (local.get $o) (local.get $char))
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 1)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (loop $x
          (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
          (br_if $x (i32.eq (i32.load8_u (i32.load8_u (;;))) (i32.const 101)))
        )
        (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
        (;;) (local.get $i)
        (i32.store (;;) (;;))
        (local.set $o (i32.add (local.get $o) (i32.const 4)))

        (call $keyword (;;)) ;; $keyword
        (br $next)
      ))
      unreachable
    )))
    (;;) (i32.const 0)
    (;;) (local.get $o)
  )

  (func $keyword (param $t i32)
    (local $i i32)

    (;;) (local.tee $i (i32.load (i32.add (local.get $t) (i32.const 1))))
    (if (i32.eq (i32.load8_u (;;)) (i32.const 118)) (then
      (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
      (if (i32.eq (i32.load8_u (;;)) (i32.const 97)) (then
        (;;) (local.tee $i (i32.add (local.get $i) (i32.const 1)))
        (if (i32.eq (i32.load8_u (;;)) (i32.const 114)) (then
          (i32.store8 (local.get $t) (i32.const 150))
          (return)
        ))
      ))
    ))
  )

  (func $primary
    (param $i i32)
    (param $len i32)
    (result i32 i32)
    ;; (<256 ? error : i, addr)
    (local $addr i32)

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 100)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 5)))
    (i32.store8 (;;) (i32.const 1)) ;; id
    (i32.store (i32.add (local.get $addr) (i32.const 1)) (local.get $i))
      ;; token_addr

    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $unary
    (param $i i32)
    (param $len i32)
    (result i32 i32)
    ;; (<256 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))

    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 2)) (then
      (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 3)) (then
        (;;) (;;) (call $primary (local.get $i) (local.get $len))
        (return (;;) (;;))
      ))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 9)))
    (i32.store8 (;;) (i32.const 2)) ;; id
    (i32.store (i32.add (local.get $addr) (i32.const 1)) (local.get $i))
      ;; token_addr

    (;;) (;;) (call $unary
      (i32.add (local.get $i) (i32.const 9))
      (local.get $len)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 5)) (local.get $expr))
      ;; expr_addr
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $factor
    (param $i i32)
    (param $len i32)
    (result i32 i32)
    ;; (<256 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (;;) (;;) (call $unary (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 4)) (then
      (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 5)) (then
        (return (local.get $i) (local.get $expr))
      ))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 13)))
    (i32.store8 (;;) (i32.const 3)) ;; id
    (i32.store (i32.add (local.get $addr) (i32.const 1)) (local.get $expr))
      ;; expr_addr1
    (i32.store (i32.add (local.get $addr) (i32.const 5)) (local.get $i))
      ;; token_addr

    (;;) (;;) (call $factor
      (i32.add (local.get $i) (i32.const 9))
      (local.get $len)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 9)) (local.get $expr))
      ;; expr_addr2
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $term
    (param $i i32)
    (param $len i32)
    (result i32 i32)
    ;; (<256 ? error : i, addr)
    (local $addr i32)
    (local $expr i32)

    (;;) (;;) (call $factor (local.get $i) (local.get $len))
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (local.get $i) (local.get $expr))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 2)) (then
      (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 3)) (then
        (return (local.get $i) (local.get $expr))
      ))
    ))

    (;;) (local.tee $addr (call $alloc (i32.const 13)))
    (i32.store8 (;;) (i32.const 4)) ;; id
    (i32.store (i32.add (local.get $addr) (i32.const 1)) (local.get $expr))
      ;; expr_addr1
    (i32.store (i32.add (local.get $addr) (i32.const 5)) (local.get $i))
      ;; token_addr

    (;;) (;;) (call $term
      (i32.add (local.get $i) (i32.const 9))
      (local.get $len)
    )
    (local.set $expr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $i) (local.get $expr))
    ))

    (i32.store (i32.add (local.get $addr) (i32.const 9)) (local.get $expr))
      ;; expr_addr2
    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $expr
    (param $i i32)
    (param $len i32)
    (result i32 i32)
    ;; (<256 ? error : i, addr)
    (local $addr i32)

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 4) (local.get $i))
    ))

    (;;) (;;) (call $term (local.get $i) (local.get $len))
    (local.set $addr (;;))
    (;;) (local.tee $i (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $i) (local.get $addr))
    ))

    (if (i32.ge_u (local.get $i) (local.get $len)) (then
      (return (i32.const 2) (local.get $i))
    ))
    (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 6)) (then
      (return (i32.const 3) (local.get $i))
    ))

    (;;) (i32.add (local.get $i) (i32.const 9))
    (;;) (local.get $addr)
  )

  (func $ast (param $i i32) (param $len i32) (result i32 i32)
    ;; (<256 ? error : i, addr)
    (local $size i32)
    (local $addr i32)
    (local $expr i32)
    (local $x i32)

    (call $disable_alloc)
    (local.set $x (local.get $i))
    (block $break (loop $next
      (;;) (;;) (call $expr (local.get $x) (local.get $len))
      (local.set $addr (;;))
      (;;) (local.tee $x (;;))
      (if (i32.eq (;;) (i32.const 4)) (then
        (br $break)
      ))
      (if (i32.lt_u (local.get $x) (i32.const 256)) (then
        (return (local.get $x) (local.get $addr))
      ))
      (local.set $size (i32.add (local.get $size) (i32.const 1)))
      (br $next)
    ))
    (call $enable_alloc)
    (if (i32.ge_u (local.get $size) (i32.const 256)) (then
      (return (i32.const 4) (i32.load (i32.add (local.get $i) (i32.const 1))))
    ))

    (;;) (i32.add (i32.mul (local.get $size) (i32.const 4)) (i32.const 2))
    (;;) (local.tee $addr (call $alloc (;;)))
    (i32.store8 (;;) (i32.const 5)) ;; id
    (i32.store8
      (i32.add (local.get $addr) (i32.const 1))
      (local.get $size)
    ) ;; size

    (local.set $x (i32.const 0))
    (local.set $size (i32.mul (local.get $size) (i32.const 4)))
    (loop $next (if (i32.lt_u (local.get $x) (local.get $size)) (then
      (;;) (;;) (call $expr (local.get $i) (local.get $len))
      (local.set $expr (;;))
      (local.set $i (;;))
      (i32.store
        (i32.add (i32.add (local.get $addr) (local.get $x)) (i32.const 2))
        (local.get $expr)
      ) ;; expr_addr(n)
      (local.set $x (i32.add (local.get $x) (i32.const 4)))
      (br $next)
    )))

    (;;) (local.get $i)
    (;;) (local.get $addr)
  )

  (func $emitPrimary (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (local $i i32)
    (local $len i32)

    (;;) (local.get $o)
    (i32.store (;;) (i32.const 842230048)) ;;  i32
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 1852793646)) ;; .con
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 2126963)) ;; "st "
    (local.set $o (i32.add (local.get $o) (i32.const 3)))

    (local.tee $addr (i32.load (i32.add (local.get $addr) (i32.const 1))))
    (local.set $i (i32.load (i32.add (;;) (i32.const 1))))
    (local.set $len (i32.load (i32.add (local.get $addr) (i32.const 5))))
    (loop $next (if (i32.lt_u (local.get $i) (local.get $len)) (then
      (i32.store8 (local.get $o) (i32.load8_u (local.get $i)))
      (local.set $o (i32.add (local.get $o) (i32.const 1)))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $next)
    )))

    (;;) (local.get $o)
  )

  (func $emitUnary (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 5)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 1))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 2)) (then
      (return (local.get $o))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 3)) (then
      (;;) (local.get $o)
      (i32.store (;;) (i32.const 842230048)) ;;  i32
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 1852793646)) ;; .con
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 757101683)) ;; st -
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 862527537)) ;; 1 i3
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 1970089522)) ;; 2.mu
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 108)) ;; l
      (return (i32.add (local.get $o) (i32.const 1)))
    ))
    unreachable
  )

  (func $emitFactor (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 1)))
    )
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 9)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 5))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 4)) (then
      (;;) (local.get $o)
      (i32.store (;;) (i32.const 842230048)) ;;  i32
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 1819634990)) ;; .mul
      (return (i32.add (local.get $o) (i32.const 4)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 5)) (then
      (;;) (local.get $o)
      (i32.store (;;) (i32.const 842230048)) ;;  i32
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 1986618414)) ;; .div
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 29535)) ;; _s
      (return (i32.add (local.get $o) (i32.const 2)))
    ))
    unreachable
  )

  (func $emitTerm (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (;;) (local.get $o)
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 1)))
    )
    (;;) (call $emitExpr
      (;;)
      (i32.load (i32.add (local.get $addr) (i32.const 9)))
    )
    (local.set $o (;;))
    (local.set $addr (i32.load (i32.add (local.get $addr) (i32.const 5))))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 2)) (then
      (;;) (local.get $o)
      (i32.store (;;) (i32.const 842230048)) ;;  i32
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 1684300078)) ;; .add
      (return (i32.add (local.get $o) (i32.const 4)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 3)) (then
      (;;) (local.get $o)
      (i32.store (;;) (i32.const 842230048)) ;;  i32
      (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
      (i32.store (;;) (i32.const 1651864366)) ;; .sub
      (return (i32.add (local.get $o) (i32.const 4)))
    ))
    unreachable
  )

  (func $emitExpr (param $o i32) (param $addr i32) (result i32)
    ;; (o)

    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 1)) (then
      (return (call $emitPrimary (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 2)) (then
      (return (call $emitUnary (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 3)) (then
      (return (call $emitFactor (local.get $o) (local.get $addr)))
    ))
    (if (i32.eq (i32.load8_u (local.get $addr)) (i32.const 4)) (then
      (return (call $emitTerm (local.get $o) (local.get $addr)))
    ))
    unreachable
  )

  (func $emitWat (param $root i32) (result i32)
    ;; (o)

    (local $o i32)
    (local $x i32)
    (local $size i32)

    (if (i32.ne (i32.load8_u (local.get $root)) (i32.const 5)) (then
      unreachable
    ))

    (;;) (local.tee $o (call $get_alloc))
    (i32.store (;;) (i32.const 1685024040)) ;; (mod
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 677735541)) ;; ule(
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 1668183398)) ;; func
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 1886938408)) ;; (exp
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 544502383)) ;; ort
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 1767992610)) ;; "mai
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 673784430)) ;; n")(
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 1970496882)) ;; resu
    (;;) (local.tee $o (i32.add (local.get $o) (i32.const 4)))
    (i32.store (;;) (i32.const 29804)) ;; lt
    (local.set $o (i32.add (local.get $o) (i32.const 2)))

    (local.set $x (i32.const 0))
    (local.set $size (i32.load8_u (i32.add (local.get $root) (i32.const 1))))
    (loop $next (if (i32.lt_u (local.get $x) (local.get $size)) (then
      (i32.store (local.get $o) (i32.const 842230048)) ;;  i32
      (local.set $o (i32.add (local.get $o) (i32.const 4)))
      (local.set $x (i32.add (local.get $x) (i32.const 1)))
      (br $next)
    )))
    (i32.store (local.get $o) (i32.const 41)) ;; )
    (local.set $o (i32.add (local.get $o) (i32.const 1)))

    (;;) (local.tee $x (i32.add (local.get $root) (i32.const 2)))
    (local.set $size (i32.add (;;) (i32.mul (local.get $size) (i32.const 4))))
    (loop $next (if (i32.lt_u (local.get $x) (local.get $size)) (then
      (;;) (call $emitExpr (local.get $o) (i32.load (local.get $x)))
      (local.set $o (;;))
      (local.set $x (i32.add (local.get $x) (i32.const 4)))
      (br $next)
    )))


    (i32.store (local.get $o) (i32.const 10537)) ;; ))
    (;;) (i32.add (local.get $o) (i32.const 2))
  )

  (func (export "compile") (param $size i32) (result i32 i32 i32)
    ;; (has_error, start_addr, end_addr)
    (local $has_error i32)
    (local $addr i32)

    (;;) (;;) (call $scan (local.get $size))
    (local.set $addr (;;))
    (;;) (local.tee $has_error (;;))
    (if (i32.ne (;;) (i32.const 0)) (then
      (return (local.get $has_error) (local.get $addr) (local.get $addr))
    ))
    (call $set_alloc (local.get $addr))

    (;;) (;;) (call $ast
      (i32.add (local.get $size) (i32.const 256))
      (local.get $addr)
    )
    (local.set $addr (;;))
    (;;) (local.tee $has_error (;;))
    (if (i32.lt_u (;;) (i32.const 256)) (then
      (return (local.get $has_error) (local.get $addr) (local.get $addr))
    ))

    (;;) (i32.const 0)
    (;;) (call $get_alloc)
    (;;) (call $emitWat (local.get $addr))
  )
)
