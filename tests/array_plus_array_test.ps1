#. ..\power_shell\array_plus_array.ps1

Describe 'array_plus_array Tests' {
    BeforeAll {
        # random_functions.ps1
        function Generate-RandomArray {
            param (
                [int]$length = 3,
                [int]$minValue = 0,
                [int]$maxValue = 10
            )
            $random = New-Object System.Random
            $array = @()
            for ($i = 0; $i -lt $length; $i++) {
                $array += $random.Next($minValue, $maxValue)
            }
            return $array
        }
    }
    # Тест 1: Проверка со случайными массивами
    It 'Should return the correct sum for random arrays' {
        $array1 = Generate-RandomArray -length (Get-Random -Minimum 1 -Maximum 5) -minValue 1 -maxValue 10
        $array2 = Generate-RandomArray -length (Get-Random -Minimum 1 -Maximum 5) -minValue 1 -maxValue 10
        $expected = ($array1 + $array2) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
 
        Write-Output "Testing with arrays: $array1 and $array2"
 
         $result = array_plus_array -array1 $array1 -array2 $array2
        # Write-Output "Result: $result"
        Write-Verbose "Expected: $expected"
 
         $result | Should -BeExactly $expected
	}
		 # Тест 2: Проверка с пустыми массивами
    It "Should return 0 when summing empty arrays" {
        $array1 = @()
        $array2 = @()
        $expected = 0

        Write-Output "Testing with empty arrays"

        $result = array_plus_array -array1 $array1 -array2 $array2
        Write-Output "Result: $result"
        Write-Output "Expected: $expected"

        $result | Should -BeExactly $expected
    }

    # Тест 3: Проверка с массивами, содержащими нули
    It "Should return the correct sum when arrays contain zeros" {
        $array1 = @(0, 0, 1, 2)
        $array2 = @(0, 3, 4)
        $expected = ($array1 + $array2) | Measure-Object -Sum | Select-Object -ExpandProperty Sum

        Write-Output "Testing with arrays: $array1 and $array2"

        $result = array_plus_array -array1 $array1 -array2 $array2
        Write-Output "Result: $result"
        Write-Output "Expected: $expected"

        $result | Should -BeExactly $expected
    }

    # Тест 4: Проверка с массивами, содержащими только положительные числа
    It "Should return the correct sum when arrays contain only positive numbers" {
        $array1 = @(1, 2, 3)
        $array2 = @(4, 5, 6)
        $expected = ($array1 + $array2) | Measure-Object -Sum | Select-Object -ExpandProperty Sum

        Write-Output "Testing with arrays: $array1 and $array2"

        $result = array_plus_array -array1 $array1 -array2 $array2
        Write-Output "Result: $result"
        Write-Output "Expected: $expected"

        $result | Should -BeExactly $expected
    }
   
}
