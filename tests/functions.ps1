function array_plus_array {
    param (
        [int[]]$array1,
        [int[]]$array2
    )

    $sum = 0

    foreach ($a in $array1) {
        $sum += $a
    }

    foreach ($b in $array2) {
        $sum += $b
    }

    return $sum
}  
