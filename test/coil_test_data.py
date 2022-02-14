import json
import sys
import random


def main():
    coil_dict = {}
    coil_dict['coils'] = []

    # coil_dict['coils'].append({'Length' : 100, 'Qty' : 36, 'Crate' : 1})
    # coil_dict['coils'].append({'Length' : 100, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 106, 'Qty' : 3, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 103, 'Qty' : 3, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 93, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 89, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 87, 'Qty' : 2, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 85, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 85, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 80.7, 'Qty' : 2, 'Crate' : 2})

    # coil_dict['coils'].append({'Length' : 77, 'Qty' : 4, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 75, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 72, 'Qty' : 2, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 70, 'Qty' : 1, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 69, 'Qty' : 3, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 64, 'Qty' : 2, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 62, 'Qty' : 2, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 60, 'Qty' : 12, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 56, 'Qty' : 2, 'Crate' : 2})
    # coil_dict['coils'].append({'Length' : 31, 'Qty' : 2, 'Crate' : 2})

    # coil_dict['coils'].append({'Length' : 100, 'Qty' : 26, 'Crate' : 3})
    # coil_dict['coils'].append({'Length' : 119, 'Qty' : 6, 'Crate' : 3})
    # coil_dict['coils'].append({'Length' : 77, 'Qty' : 1, 'Crate' : 3})
    # coil_dict['coils'].append({'Length' : 90, 'Qty' : 1, 'Crate' : 3})
    # coil_dict['coils'].append({'Length' : 88, 'Qty' : 2, 'Crate' : 3})
    # coil_dict['coils'].append({'Length' : 100, 'Qty' : 20, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 93, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 91, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 87, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 79, 'Qty' : 1, 'Crate' : 4})

    # coil_dict['coils'].append({'Length' : 74, 'Qty' : 2, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 65, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 63, 'Qty' : 2, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 56, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 52, 'Qty' : 4, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 46, 'Qty' : 2, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 39, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 32, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 28, 'Qty' : 1, 'Crate' : 4})
    # coil_dict['coils'].append({'Length' : 23, 'Qty' : 2, 'Crate' : 4})

    # coil_dict['coils'].append({'Length' : 100, 'Qty' : 28, 'Crate' : 5})
    # coil_dict['coils'].append({'Length' : 103, 'Qty' : 3, 'Crate' : 5})
    # coil_dict['coils'].append({'Length' : 93, 'Qty' : 1, 'Crate' : 5})
    # coil_dict['coils'].append({'Length' : 92.5, 'Qty' : 3, 'Crate' : 5})
    # coil_dict['coils'].append({'Length' : 90, 'Qty' : 1, 'Crate' : 5})
    # coil_dict['coils'].append({'Length' : 100, 'Qty' : 17, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 103, 'Qty' : 1, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 90, 'Qty' : 6, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 80, 'Qty' : 1, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 61, 'Qty' : 2, 'Crate' : 6})

    # coil_dict['coils'].append({'Length' : 58, 'Qty' : 3, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 49, 'Qty' : 2, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 47, 'Qty' : 2, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 44, 'Qty' : 3, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 42, 'Qty' : 1, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 36, 'Qty' : 3, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 33, 'Qty' : 1, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 29.5, 'Qty' : 2, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 26, 'Qty' : 3, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 20, 'Qty' : 2, 'Crate' : 6})
    # coil_dict['coils'].append({'Length' : 16, 'Qty' : 3, 'Crate' : 6})

    for i in range(40):
        coil_dict['coils'].append({'Length' : random.randint(1, 150), 'Qty' : random.randint(1, 100), 'Crate' : random.randint(1,10)})

    with open(sys.argv[1], 'w') as f:
        json.dump(coil_dict, f, indent=2)



if __name__ == '__main__':
    main()
