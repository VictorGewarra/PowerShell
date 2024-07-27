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

$array1 = [int[]](1, 2, 3)
$array2 = [int[]](1, 2, 3)

array_plus_array -array1 $array1 -array2 $array2