(module
    (memory (export "memory") 1)

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

        (global.get $alloc)
        (global.set $alloc (i32.add (global.get $alloc) (local.get $size)))
    )

    (func $set_alloc (param $addr i32) (result)
        (global.set $alloc (local.get $addr))
    )

    (data (i32.const 0) "\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00")
    (data (i32.const 16) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 32) "\01\00\00\00\00\00\00\00\00\00\04\02\00\03\00\05")
    (data (i32.const 48) "\06\06\06\06\06\06\06\06\06\06\00\00\00\00\00\00")
    (data (i32.const 64) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 80) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 96) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 112) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 128) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 144) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 160) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 176) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 192) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 208) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 224) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
    (data (i32.const 240) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")

    (func $scan (param $size i32) (result i32 i32) ;; (has_error, addr)
        (local $i i32)
        (local $o i32)
        (local $char i32)

        (local.tee $i (i32.const 256))
        (local.tee $size (i32.add (;;) (local.get $size)))
        (local.set $o (;;))

        (loop $next (if (i32.lt_u (local.get $i) (local.get $size)) (then
            (local.tee $char (i32.load8_u (i32.load8_u (local.get $i))))
            (if (i32.eqz (;;)) (then
                (return (i32.const 1) (local.get $i))
            ))
            (if (i32.eq (local.get $char) (i32.const 1)) (then
                (local.set $i (i32.add (local.get $i) (i32.const 1)))
                (br $next)
            ))
            (if (i32.ge_u (local.get $char) (i32.const 2)) (then
                (if (i32.le_u (local.get $char) (i32.const 5)) (then
                    (i32.store8 (local.get $o) (local.get $char))
                    (local.tee $o (i32.add (local.get $o) (i32.const 1)))
                    (local.get $i)
                    (i32.store (;;) (;;))
                    (local.tee $o (i32.add (local.get $o) (i32.const 4)))
                    (local.tee $i (i32.add (local.get $i) (i32.const 1)))
                    (i32.store (;;) (;;))
                    (local.set $o (i32.add (local.get $o) (i32.const 4)))
                    (br $next)
                ))
            ))
            (if (i32.eq (local.get $char) (i32.const 6)) (then
                (i32.store8 (local.get $o) (local.get $char))
                (local.tee $o (i32.add (local.get $o) (i32.const 1)))
                (local.get $i)
                (i32.store (;;) (;;))
                (loop $num
                    (local.tee $i (i32.add (local.get $i) (i32.const 1)))
                    (br_if $num
                        (i32.eq (i32.load8_u (i32.load8_u (;;))) (i32.const 6))
                    )
                )
                (local.tee $o (i32.add (local.get $o) (i32.const 4)))
                (local.get $i)
                (i32.store (;;) (;;))
                (local.set $o (i32.add (local.get $o) (i32.const 4)))
                (br $next)
            ))
            unreachable
        )))
        (i32.const 0)
        (local.get $o)
    )

    (func (export "compile") (param $size i32) (result i32 i32 i32) ;; (has_error, addr)
        (local $has_error i32)
        (local $addr i32)

        (local.tee $has_error (local.set $addr (call $scan (local.get $size))))
        (if (i32.ne (i32.const 0) (;;)) (then
            (return (local.get $has_error) (local.get $addr) (local.get $addr))
        ))
        (call $set_alloc (local.get $addr))
        i32.const 0
        (i32.add (local.get $size) (i32.const 256))
        local.get $addr
    )
)
